-- Platform detection utilities for cross-platform Neovim config
local M = {}

-- Cache results to avoid repeated filesystem checks
local _cache = {}

--- Check if running on Windows
---@return boolean
function M.is_windows()
  if _cache.is_windows == nil then
    _cache.is_windows = vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1
  end
  return _cache.is_windows
end

--- Check if running on Linux
---@return boolean
function M.is_linux()
  if _cache.is_linux == nil then
    _cache.is_linux = vim.fn.has("unix") == 1 and not M.is_mac()
  end
  return _cache.is_linux
end

--- Check if running on macOS
---@return boolean
function M.is_mac()
  if _cache.is_mac == nil then
    _cache.is_mac = vim.fn.has("mac") == 1 or vim.fn.has("macunix") == 1
  end
  return _cache.is_mac
end

--- Check if running in WSL (Windows Subsystem for Linux)
---@return boolean
function M.is_wsl()
  if _cache.is_wsl == nil then
    _cache.is_wsl = false
    if M.is_linux() then
      local proc_version = vim.fn.readfile("/proc/version")
      if proc_version and #proc_version > 0 then
        local version_str = proc_version[1]:lower()
        _cache.is_wsl = version_str:match("microsoft") ~= nil or version_str:match("wsl") ~= nil
      end
    end
  end
  return _cache.is_wsl
end

--- Get the path separator for current OS
---@return string
function M.path_sep()
  return M.is_windows() and "\\" or "/"
end

--- Check if a command/executable exists
---@param cmd string
---@return boolean
function M.executable(cmd)
  return vim.fn.executable(cmd) == 1
end

--- Get Windows path from WSL path (e.g., /mnt/c/... -> C:\...)
---@param wsl_path string
---@return string
function M.wsl_to_windows_path(wsl_path)
  if not M.is_wsl() then
    return wsl_path
  end
  -- Convert /mnt/c/path/to/file -> C:\path\to\file
  local win_path = wsl_path:gsub("^/mnt/(%w)/", function(drive)
    return drive:upper() .. ":\\"
  end)
  return win_path:gsub("/", "\\")
end

--- Get WSL path from Windows path (e.g., C:\... -> /mnt/c/...)
---@param win_path string
---@return string
function M.windows_to_wsl_path(win_path)
  if not M.is_wsl() then
    return win_path
  end
  -- Convert C:\path\to\file -> /mnt/c/path/to/file
  local wsl_path = win_path:gsub("^(%w):\\", function(drive)
    return "/mnt/" .. drive:lower() .. "/"
  end)
  return wsl_path:gsub("\\", "/")
end

--- Check if dotnet CLI is available
---@return boolean
function M.has_dotnet()
  if _cache.has_dotnet == nil then
    _cache.has_dotnet = M.executable("dotnet")
  end
  return _cache.has_dotnet
end

--- Check if mono is available (for legacy .NET on Linux)
---@return boolean
function M.has_mono()
  if _cache.has_mono == nil then
    _cache.has_mono = M.executable("mono")
  end
  return _cache.has_mono
end

--- Get .NET SDK version if available
---@return string|nil
function M.dotnet_version()
  if not M.has_dotnet() then
    return nil
  end
  if _cache.dotnet_version == nil then
    local result = vim.fn.system("dotnet --version")
    if vim.v.shell_error == 0 then
      _cache.dotnet_version = vim.trim(result)
    end
  end
  return _cache.dotnet_version
end

--- Detect project type from .csproj file
--- Returns "legacy" for .NET Framework, "modern" for .NET Core/5+, nil if unknown
---@param csproj_path string|nil Path to .csproj file, or nil to search
---@return string|nil project_type
---@return string|nil target_framework
function M.detect_dotnet_project_type(csproj_path)
  -- Find .csproj if not provided
  if not csproj_path then
    local csproj_files = vim.fn.glob("*.csproj", false, true)
    if #csproj_files == 0 then
      csproj_files = vim.fn.glob("**/*.csproj", false, true)
    end
    if #csproj_files > 0 then
      csproj_path = csproj_files[1]
    else
      return nil, nil
    end
  end

  local content = vim.fn.readfile(csproj_path)
  if not content or #content == 0 then
    return nil, nil
  end

  local content_str = table.concat(content, "\n")

  -- Modern .NET Core/5+ uses <TargetFramework>
  local modern_tf = content_str:match("<TargetFramework>([^<]+)</TargetFramework>")
  if modern_tf then
    return "modern", modern_tf
  end

  -- Also check for multiple targets
  local modern_tfs = content_str:match("<TargetFrameworks>([^<]+)</TargetFrameworks>")
  if modern_tfs then
    return "modern", modern_tfs
  end

  -- Legacy .NET Framework uses <TargetFrameworkVersion>
  local legacy_tf = content_str:match("<TargetFrameworkVersion>([^<]+)</TargetFrameworkVersion>")
  if legacy_tf then
    return "legacy", legacy_tf
  end

  return nil, nil
end

--- Get platform summary for debugging
---@return table
function M.get_summary()
  return {
    is_windows = M.is_windows(),
    is_linux = M.is_linux(),
    is_mac = M.is_mac(),
    is_wsl = M.is_wsl(),
    has_dotnet = M.has_dotnet(),
    has_mono = M.has_mono(),
    dotnet_version = M.dotnet_version(),
  }
end

--- Print platform summary (useful for debugging)
function M.print_summary()
  local summary = M.get_summary()
  print("Platform Summary:")
  for k, v in pairs(summary) do
    print(string.format("  %s: %s", k, tostring(v)))
  end
end

return M
