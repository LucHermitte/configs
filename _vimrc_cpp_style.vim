"=============================================================================
" File:         dev/Optims/src/ITK/Modules/Core/_vimrc_cpp_style.vim {{{1
" Author:       Luc Hermitte <EMAIL:hermitte {at} gmail {dot} com>
"		<URL:http://github.com/LucHermitte/��>
" Version:      0.0.1.
let s:k_version = 001
" Created:      04th Jun 2015
" Last Update:
"------------------------------------------------------------------------
" Description:
"       Definition of vim's local options for the project ITK
"
"------------------------------------------------------------------------
" Installation:
"       The file must be present in a directory parent of every directories
"       where the definitions must apply.
" History:      «history»
" TODO:         «missing features»
" }}}1
"=============================================================================

let s:script_dir = expand('<sfile>:p:h')
" ======================[ Project's style ]===================

" This file is meant to be included by a local .vimrc

" ## ======================[ Project's settings {{{1
setlocal expandtab
setlocal tw=79
echomsg "Load style!"
let s:currently_edited_file = expand('%:p')
if s:currently_edited_file !~ 'OssimPlugins'
  setlocal cinoptions={1s,:0,l1,g0,c0,(0,(s,m1 " ITK/VTK style indenting
  setlocal sw=2
else
  " Usual indent options
  setlocal cinoptions=g0,t0,h1s,i0
  setlocal sw=3
endif
setlocal matchpairs+=<:>

" ## ======================[ Naming conventions {{{1
" This is used by lh-refactor, and all lh-cpp snippets for mu-template
" :h lh#dev#naming

" # core variables names {{{2
" (extract any getter, global, ... decoration)
" let b:cpp_naming_strip_subst = '\l\1' " default
" You may have to play with b:cpp_naming_strip_re to remove naming convention not
" handled by default

" # local variables {{{2
"let b:c_naming_local_subst = '\l&'              " variable " default
"let b:c_naming_local_subst = 'l_\l&'            " l_variable
"let b:c_naming_local_subst = 'l\U&'             " lVariable

" # global variables {{{2
"let b:c_naming_global_subst = '\l&'             " variable
"let b:c_naming_global_subst = 'g_\l&'           " g_variable " default
"let b:c_naming_global_subst = 'g\U&'            " gVariable

" # static variables {{{2
"let b:c_naming_static_subst = '\l&'             " variable
"let b:c_naming_static_subst = 's_\l&'           " s_variable " default
"let b:c_naming_static_subst = 's\U&'            " sVariable

" # constants {{{2
"let b:c_naming_constant_subst = '\U&\E'         " CONSTANT " default
"let b:c_naming_constant_subst = 'k_\l&'         " s_constant
"let b:c_naming_constant_subst = 'k\U&'          " sConstant

" # parameters {{{2
"let b:c_naming_param_subst = '&'                " parameter " default
"let b:c_naming_param_subst = 'p_\l&'            " p_parameter " please, no!
"let b:c_naming_param_subst = '\l&_'             " parameter_

" # member variables {{{2
"let b:cpp_naming_member_subst = '\l&'             " attribute
"let b:cpp_naming_member_subst = 'm_\l&'           " m_attribute " default
"let b:cpp_naming_member_subst = 'm\U&'            " mVariable
"let b:cpp_naming_member_subst = 'my\U&'           " myVariable
"let b:cpp_naming_member_subst = '\l&_'            " attribute_

" # types {{{2
" let b:cpp_naming_type         = 'lowerCamelCase' " unusualStuff
" let b:cpp_naming_type         = 'UpperCamelCase' " UsualStuff " default
" let b:cpp_naming_type         = 'snake_case'     " a_la_lib_std
"
" let b:cpp_naming_type_re      = '.*'
" let b:cpp_naming_type_subst   = '&'              " Typename " default
" let b:cpp_naming_type_subst   = 'T&'             " TTypenname
" let b:cpp_naming_type_subst   = '&_t'            " Typenname_t

" # functions {{{2
" let b:cpp_naming_function     = 'lowerCamelCase' " usualStuff " default
let b:cpp_naming_function     = 'UpperCamelCase' " ALaC#
" let b:cpp_naming_function     = 'snake_case'     " a_la_lib_std

" # getters {{{2
" let b:cpp_naming_strip_getter = '\l\1'           " name()
" let b:cpp_naming_strip_getter = 'get\u&'         " getName() "  default
let b:cpp_naming_strip_getter = 'Get\u&'         " GetName()
" let b:cpp_naming_strip_getter = 'get_\l&'        " get_name()

" # ref getters (total de-encapsulation) {{{2
" let b:cpp_naming_strip_ref_getter = '\l\1'       " name()
" let b:cpp_naming_strip_ref_getter = 'get\u&'     " getName()
" let b:cpp_naming_strip_ref_getter = 'get_\l&'    " get_name()
" let b:cpp_naming_strip_ref_getter = 'ref\u&'     " refName()  "  default
" let b:cpp_naming_strip_ref_getter = 'ref_\l&'    " ref_name()

" # proxy getters {{{2
" let b:cpp_naming_strip_ref_getter = '\l\1'       " name()
" let b:cpp_naming_strip_ref_getter = 'get\u&'     " getName()
" let b:cpp_naming_strip_ref_getter = 'get_\l&'    " get_name()
" let b:cpp_naming_strip_ref_getter = 'proxy\u&'   " proxyName()  "  default
" let b:cpp_naming_strip_ref_getter = 'proxy_\l&'  " proxy_name()

" # setters {{{2
" let b:cpp_naming_strip_setter = '\l\1'           " name(value)
" let b:cpp_naming_strip_setter = 'set\u&'         " setName(value) "  default
let b:cpp_naming_strip_setter = 'Set\u&'         " SetName(value)
" let b:cpp_naming_strip_setter = 'set_\l&'        " set_name(value)

" ## ======================[ lh-refactor options {{{1
" # getter {{{2
" - documentation
" let b:cpp_refactor_getter_doc   = '/** ${_ppt_name}\ getter. */\n'
" - new lines or not to introduce getter code
" let b:cpp_refactor_getter_open  = ' { '  " default
" let b:cpp_refactor_getter_close = '}'
" let b:cpp_refactor_getter_open  = ' {\n' " à la Java
" let b:cpp_refactor_getter_close = '\n}'
" let b:cpp_refactor_getter_open  = '\n{\n' " everything on a separate line
" let b:cpp_refactor_getter_close = '\n}'

" # setter {{{2
" - documentation
" let b:cpp_refactor_setter_doc   = '/** ${_ppt_name}\ setter. */\n'
" - new lines or not to introduce setter code
" let b:cpp_refactor_setter_open  = ' { '  " default
" let b:cpp_refactor_setter_close = '}'
" let b:cpp_refactor_setter_open  = ' {\n' " à la Java
" let b:cpp_refactor_setter_close = '\n}'
" let b:cpp_refactor_setter_open  = '\n{\n' " everything on a separate line
" let b:cpp_refactor_setter_close = '\n}'

" ## ======================[ Doxygen snippets {{{1
let b:dox_CommentLeadingChar = '*'
let b:dox_TagLeadingChar     = '\'
let b:dox_ingroup            = '1'
let b:dox_brief              = '1'
let b:dox_author_tag         = 'author'
let b:dox_author             = Author('name')


" ## ======================[ GOTOIMPL code generation of function bodies {{{1
" Possible values:
"   0: In the inline section of the header/current file
"   1: In the inline section of a dedicated inline file
let b:implPlace                 = 2 " transl. unit (.cpp)
" ShowVirtual = 0 -> '' ; 1 -> '/*virtual*/'
let g:cpp_ShowVirtual           = 1
" ShowStatic  = 0 -> '' ; 1 -> '/*static*/'
let g:cpp_ShowStatic            = 1
" ShowExplicit= 0 -> '' ; 1 -> '/*explicit*/'
let g:cpp_ShowExplicit 		= 1
" ShowDefaultParam = 0 -> '' ;
" 		     1 -> default value for params within comments ;
"		     2 -> within comment as well, but spaces are trimmed ;
"		     3 -> like 2, but the equal sign is not displayed.
let g:cpp_ShowDefaultParam      = 1

" Preference regarding where functions definitions are written
"
" Possible Values:
"   0: At the end of the file plus offset g:cpp_FunctionPosArg
"   1: Search for a specific pattern g:cpp_FunctionPosArg
"      Useful if you use template skeletons
"   2: Call a user specified function : g:cpp_FunctionPosArg
"      Beware! This is a (security) back door.
"   3: Store the value in a temporary variable ; to be used in conjunction
"      with :PASTEIMPL -- Robert Kelly IV's approach
let g:cpp_FunctionPosition = 2
if exists('g:cpp_FunctionPosArg') | unlet g:cpp_FunctionPosArg | endif

" ## ======================[ Misc {{{1
" Write each '(' on a new line; -> if \n() ... {}
" let b:c_nl_before_bracket                  = 0
AddStyle -b ( (
  " ))
" Write each '{' on a new line; -> if ...() \n {}
" let b:c_nl_before_curlyB                   = 0
AddStyle {  -b -ft=c -prio=10 \n{\n
  " }}
" Write each "namespace Foo {" on a same line
let b:cpp_multiple_namespaces_on_same_line = 1

" ## ======================[ Expansion of function snippets {{{1
" The following options apply when expanding template-files that generate new
" fonctions.
" NB: not all template-files may respect these parameters. If you found any,
" please contact me (see <http://code.google.com/p/lh-vim/wiki/contact>) as
" this is a bug.
"
" Must we also generate an associated documentation ?
let b:cpp_template_expand_doc = 1

" Ordered list of doxygen tags to write before the main body of the comment
let b:c_pre_desc_ordered_tags = [ "ingroup", "brief", "param", "return", "throw", "invariant", "pre", "post"]
" Ordered list of doxygen tags to write after the main body of the comment
let b:c_post_desc_ordered_tags = ["note", "warning"]
"=============================================================================
" vim600: set fdm=marker:
