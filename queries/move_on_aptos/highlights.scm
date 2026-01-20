; =========================
; Comments / doc comments
; =========================
(line_comment) @comment
(doc_comment) @comment.documentation

; =========================
; Module header
; module foo::bar { ... }
; =========================
(module
  path: (identifier) @namespace
  name: (identifier) @namespace)

(module) @module

; =========================
; use declarations
; =========================
(use_decl) @keyword.import

(module_ident
  (identifier) @module
  module_name: (identifier) @module)

(member (identifier) @type (alias) @type)
(member (identifier) @type)

; =========================
; Decls
; =========================
(function_decl name: (identifier) @function)
(struct_decl name: (identifier) @type)
(constant_decl name: (identifier) @constant)

; Params / locals
(parameter variable: (identifier) @variable.parameter)
(var_name (identifier) @variable)

; =========================
; Types
; =========================
(primitive_type) @type.builtin
(number_type) @type.builtin

(type (name_access_chain (identifier) @type))
(type_args (type (name_access_chain (identifier) @type)))

; =========================
; Struct packs + fields
; =========================
(pack_expr struct_name: (name_access_chain (identifier) @type))
(field_annot field: (identifier) @property)
(expr_field field: (identifier) @property)
(access_field field: (identifier) @property)

; =========================
; ALL_CAPS constants (local consts, error codes, etc.)
; =========================
((identifier) @constant
 (#match? @constant "^[A-Z][A-Z0-9_]*$"))

; =========================
; Attributes: #[event]
; =========================
(attributes) @attribute

; =========================
; Paths / qualified names
; foo::bar (neutral)
; =========================
(name_access_chain
  (identifier) @namespace
  (identifier) @property)

; =========================
; Calls
; foo(...)
; option::some(...)
; =========================
(call_expr
  func_name: (name_access_chain
    (identifier) @namespace
    (identifier) @function))

(call_expr
  func_name: (name_access_chain
    name: (identifier) @function))

; =========================
; Vars
; a, b, metadata, etc.
; =========================
(var (name_access_chain name: (identifier) @variable))

; =========================
; Control flow + operators
; =========================
(if_expr) @keyword
(return_expr) @keyword.return
(let_expr) @keyword
(not_expr) @operator
(binary_operator) @operator
(bin_op_expr) @operator

; =========================
; Literals
; =========================
(bool_literal) @boolean
(number) @number

; =========================
; Abilities: copy, drop, store, key
; =========================
(ability) @keyword
