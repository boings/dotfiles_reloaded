local M = {}

local function is_doc_comment(line)
  return line:match "^%s*///"
end

local function is_decl_start(line)
  -- Good enough for Move. Extend as needed.
  return line:match "^%s*public%s+fun%s+"
    or line:match "^%s*fun%s+"
    or line:match "^%s*public%s+struct%s+"
    or line:match "^%s*struct%s+"
end

local function extract_doc_and_signature(lines, lnum0)
  -- lnum0 is 0-based, lua tables are 1-based
  local i = lnum0 + 1

  -- Find the declaration line (sometimes definition points at the name token;
  -- walk up a bit to find the start of the declaration)
  local decl_i = i
  for j = i, math.max(1, i - 200), -1 do
    if is_decl_start(lines[j] or "") then
      decl_i = j
      break
    end
  end

  -- Collect contiguous /// lines immediately above decl
  local docs = {}
  local j = decl_i - 1
  while j >= 1 and is_doc_comment(lines[j] or "") do
    table.insert(docs, 1, (lines[j]:gsub("^%s*///%s?", "")))
    j = j - 1
  end

  -- Signature: take the decl line, and optionally continue until '{' or ';'
  local sig = (lines[decl_i] or ""):gsub("^%s+", "")
  if not sig:find "{" and not sig:find ";" then
    for k = decl_i + 1, math.min(#lines, decl_i + 6) do
      local ln = (lines[k] or ""):gsub("^%s+", "")
      sig = sig .. " " .. ln
      if ln:find "{" or ln:find ";" then
        break
      end
    end
  end
  sig = sig:gsub("%s+", " "):gsub("%s*{%s*$", " {"):gsub("%s*;%s*$", ";")

  return docs, sig
end

function M.hover_or_doc_fallback()
  local params = vim.lsp.util.make_position_params(0, "utf-16")

  -- 1) Ask for definition first so we can read docs from source
  vim.lsp.buf_request(0, "textDocument/definition", params, function(_, def_result)
    local function fallback_to_hover()
      vim.lsp.buf_request(0, "textDocument/hover", params, function(_, hover_result)
        local contents = hover_result and hover_result.contents
        if not contents or contents == "null" then
          vim.lsp.buf.definition()
          return
        end
        vim.lsp.buf.hover()
      end)
    end

    if not def_result or vim.tbl_isempty(def_result) then
      fallback_to_hover()
      return
    end

    local loc = def_result[1].targetUri
        and def_result[1].targetRange
        and {
          uri = def_result[1].targetUri,
          range = def_result[1].targetRange,
        }
      or def_result[1]

    local uri = loc.uri or loc.targetUri
    local range = loc.range or loc.targetRange
    if not uri or not range then
      fallback_to_hover()
      return
    end

    local path = vim.uri_to_fname(uri)
    local ok, lines = pcall(vim.fn.readfile, path)
    if not ok or not lines then
      fallback_to_hover()
      return
    end

    local docs, sig = extract_doc_and_signature(lines, range.start.line)

    -- If we actually found docs, show them (this is what you want for AptosFramework)
    if docs and #docs > 0 then
      local title = ("**%s**"):format(vim.fn.fnamemodify(path, ":~:."))
      local out = {}

      -- signature first
      if sig and sig ~= "" then
        table.insert(out, sig)
      end

      -- blank line then docs
      if #docs > 0 then
        table.insert(out, "")
        vim.list_extend(out, docs)
      end

      vim.g._last_move_hover_title = title
      vim.g._last_move_hover_lines = out

      M.show_move_doc_popup(out, title)
      return
    end

    -- Otherwise: hover (it might at least give a signature)
    fallback_to_hover()
  end)
end

-- Keep track of the last hover float
local last_hover = { win = nil, buf = nil }

local function is_valid_win(win)
  return win and vim.api.nvim_win_is_valid(win)
end

local function is_valid_buf(buf)
  return buf and vim.api.nvim_buf_is_valid(buf)
end

local function show_float(lines, title)
  local out = {}
  if title then
    table.insert(out, title)
  end
  if lines and #lines > 0 then
    if title then
      table.insert(out, "")
    end
    vim.list_extend(out, lines)
  end

  local buf, win = vim.lsp.util.open_floating_preview(out, "markdown", {
    border = "rounded",
    focusable = true, -- must be true to allow focusing later
    focus = false, -- but don't steal focus on first K
  })

  last_hover.buf = buf
  last_hover.win = win

  -- Make it easy to close
  vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = buf, silent = true })

  return buf, win
end

-- Call this when you want to display/update your doc popup
function M.show_move_doc_popup(lines, title)
  -- If a hover window exists, close and recreate (simplest + avoids stale content)
  if is_valid_win(last_hover.win) then
    pcall(vim.api.nvim_win_close, last_hover.win, true)
    last_hover.win, last_hover.buf = nil, nil
  end
  show_float(lines, title)
end

-- This is what you map to K:
-- 1st press: show popup if not open
-- 2nd press: focus popup if open
function M.hover_toggle_focus(async_build_fn)
  if is_valid_win(last_hover.win) and is_valid_buf(last_hover.buf) then
    vim.api.nvim_set_current_win(last_hover.win)
    return
  end

  -- Start the async build; it will show the popup when ready
  async_build_fn()
end

return M
