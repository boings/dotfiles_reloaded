; =========================
; Comments / doc comments
; =========================
(line_comment) @comment
(doc_comment) @comment.documentation

; =========================
; Module header: flipper_clmm::clmm_v3_skeleton
; module flipper_clmm::clmm_v3_skeleton { ... }
; =========================
(module
  path: (identifier) @attribute
  name: (identifier) @attribute)

(module) @module

; =========================
; use declarations
; =========================
(use_decl) @keyword.import

(module_ident
  (identifier) @module
  module_name: (identifier) @module)

(member
  (identifier) @type
  (alias) @type)

(member
  (identifier) @type)

; =========================
; Functions and params
; public fun make_fungible_descriptor(metadata: Object<Metadata>): AssetDescriptor
; =========================
(function_decl name: (identifier) @function)

(parameter variable: (identifier) @variable.parameter)

; =========================
; Types (return types, param types, type args)
; =========================
(type (name_access_chain (identifier) @type))
(type_args (type (name_access_chain (identifier) @type)))

; Struct pack name: AssetDescriptor { ... }
(pack_expr struct_name: (name_access_chain (identifier) @type))

; =========================
; Field names in struct packs: kind:, coin:, metadata:
; =========================
(expr_field field: (identifier) @property)

; =========================
; Paths / qualified names
; =========================

; neutral path coloring: option::something
(name_access_chain
  (identifier) @module
  (identifier) @property)

; =========================
; Calls
; =========================

; foo(...)
(call_expr
  func_name: (name_access_chain
               (identifier) @namespace
               (identifier) @function))

(call_expr 
  func_name: (name_access_chain
  name: (identifier) @function))

; =========================
; Constants: ALL_CAPS
; =========================
((identifier) @constant
 (#match? @constant "^[A-Z][A-Z0-9_]*$"))


; =========================
; Structs
; struct PositionInfo has copy, drop, store { ... }
; =========================
(struct_decl
  name: (identifier) @type)

; Abilities: copy, drop, store, key
(abilities (ability) @keyword)
(ability) @keyword

; Field annotations: liquidity: u128,
(field_annot
  field: (identifier) @property)

; Primitive types: u64, u128, bool, address, etc.
(primitive_type) @type.builtin
(number_type) @type.builtin

; =========================
; Attributes: #[event]
; =========================
(attributes) @attribute
; (attribute attr_path: (identifier) @attribute)


(field_annot field: (identifier) @property)

; =========================
; Constants
; =========================
(constant_decl name: (identifier) @constant)

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

; Numbers – node names vary; cover the ones we’ve seen
(number_type) @type.builtin
(number) @number

; let (a_neg, a_mag) = ...
(var_name (identifier) @variable)

; a, b, metadata, etc.
(var (name_access_chain name: (identifier) @variable))

; a.kind / b.kind
(access_field field: (identifier) @property)




; neutral path coloring
(name_access_chain
  (identifier) @namespace
  (identifier) @property)

; but when used as a function in a call, override
