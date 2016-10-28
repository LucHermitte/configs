
"=============================================================================
" File:         dev/(ITK|OTB)/_vimrc_local.vim  {{{1
" Author:       Luc Hermitte <EMAIL:hermitte {at} c-s {dot} fr>
let s:k_version = 188
" Created:      04th Jun 2015
" Last Update:28th Oct 2016
"------------------------------------------------------------------------
" Description:
"       Definition of vim's local options for the projects ITK and OTB
"
"------------------------------------------------------------------------
" Installation:
"       The file must be present in a directory parent of every directories
"       where the definitions must apply.
" }}}1
"=============================================================================

" ######################################################################
" Always loaded {{{1
" Here goes settings from plugins that are not project aware :(

" 2x:h -> remove file name -> move dir up from .config/
let s:script_dir = expand('<sfile>:p:h:h')
let s:config_dir = expand('<sfile>:p:h')
let s:currently_edited_file = expand('%:p')
call lh#let#to('g:BTW.use_project', 1) " test old and new BTW interface w/ p: support
let lh#project.auto_detect = 0

" Alternate configuration {{{2
" let g:alternateSearchPath = 'reg:#\<src\>$#inc,reg:#\<inc\>$#src#'
" .h and .cpp are in the same directory
let g:alternateSearchPath = 'sfr:.,reg:#\<src\>$#include,reg:#\<include\>$#src#'
if s:currently_edited_file =~ 'OssimPlugins'
  let g:alternateExtensions_cpp = "h"
  let g:alternateExtensions_h   = "cpp"
else
  let g:alternateExtensions_cxx = "h,hxx"
  let g:alternateExtensions_h   = "cxx,hxx,txx"
  let g:alternateExtensions_hxx = "cxx,hxx,txx"
  let g:alternateExtensions_txx = "h,hxx"
endif

" ######################################################################
" Buffer-local Definitions {{{1
" Avoid local reinclusion {{{2
if &cp || (exists("b:loaded_ITKnOTB_vimrc_local")
      \ && (b:loaded_ITKnOTB_vimrc_local >= s:k_version)
      \ && !exists('g:force_reload_ITKnOTB_vimrc_local'))
  " finish
endif
let b:loaded_ITKnOTB_vimrc_local = s:k_version
let s:cpo_save=&cpo
set cpo&vim
" Avoid local reinclusion }}}2

let s:script = expand("<sfile>:p")

" ======================[ Check for excluded files => abort {{{2
if empty(s:currently_edited_file)
    let s:currently_edited_file = getcwd()
endif
" if s:currently_edited_file =~ '^fugitive://\|----<Jobs>----\|^\d*$'
if s:currently_edited_file =~ '^fugitive://$'
  call lh#log#this('Not a real source file, aborting')
  finish
endif
let s:rel_path_to_current = lh#path#strip_start(s:currently_edited_file, [s:script_dir])
if s:rel_path_to_current !~ 'ITK\|OTB'
    " Not ITK/OTB, aborting
    call lh#log#this('Not ITK/OTB, aborting')
    finish
endif
" if !lh#project#is_in_a_project()
  " finish
" endif

" ======================[ Commun stuff {{{2
runtime autoload/lh/project.vim

if lh#project#is_in_a_project() && ! get(g:, 'force_reload_ITKnOTB_vimrc_local', 0)
  finish
endif

call lh#let#unlet('b:'.g:lh#project#varname)
call lh#project#define(s:, { 'name': 'ITK_OTB', 'auto_discover_root':0 }, 'project_common')

"TODO:
"- recognize when the project already existed
"  => don't execute the LetTo & co
"- and this at common + at component (OTB, ITK) level

" ----------------------[ Project's style {{{3
" ---[ Style
silent! source <sfile>:p:h/_vimrc_cpp_style.vim
" ---[ Templates
" Where templates related to the project will be stored. You'll have to
" adjust the number of ':h', -> :h expand()
call lh#let#to('p:mt_templates_paths', s:config_dir.'/templates')

"-----------------------[ &path {{{2
" don't search into included file how to complete
LetTo p:&complete-=i
"
" ----------------------[ tags generation {{{2
" Be sure tags are automatically updated on the current file
LetIfUndef p:tags_options.no_auto 0
" Declare the indexed filetypes
call lh#tags#add_indexed_ft('c', 'cpp')
" Register ITK/OTB extensions as C++ extensions
call lh#tags#set_lang_map('cpp', '+.txx')

" TODO: projectify these pathnames
" You'll have to generate thoses files for your system...
let &l:tags=lh#path#munge(&l:tags, $HOME.'/dev/tags/stl.tags')
let &l:tags=lh#path#munge(&l:tags, $HOME.'/dev/tags/boost.tags')
" ITK and OTB
let &l:tags=lh#path#munge(&l:tags, $HOME.'/dev/ossim/ossim/src/tags')
" let &l:tags=lh#path#munge(&l:tags, $HOME.'/dev/tags/itk.tags')
" let &l:tags=lh#path#munge(&l:tags, $HOME.'/dev/tags/otb.tags')

" ======================[ Settings for compil_hints {{{2
LetTo p:compil_hints_autostart = 1

" ----------------------[ Settings for BTW {{{2
let s:BTW_substitute_names = [
      \     ['VariableLengthVector<', 'VLV<'],
      \     ['VariableLengthVectorExpression', 'VLVEB'],
      \     ['VariableLengthVectorUnaryExpression', 'VLVEU'],
      \     ['ossimplugins', 'O']
      \ ]
call lh#let#if_undef('p:BTW.substitute_filenames', s:BTW_substitute_names)
QFImport BTW_substitute_names
BTW addlocal substitute_filenames

if SystemDetected() == 'msdos'
  :BTW setlocal cmake
  " echomsg SystemDetected()
  if SystemDetected() == 'unix' " cygwin
    " then cygwin's cmake does not work -> use win32 cmake
    let $PATH=substitute($PATH, '\(.*\);\([^;]*CMake[^;]*\)', '\2;\1', '')
    BTW addlocal cygwin
  endif
endif
:BTW addlocal STLFilt

LetIfUndef p:BTW.executable.type 'ctest'
" sets p:BTW.executable.rule
if ! g:BTW.use_project
  call g:{s:component_varname}_config_menu.def_ctest_targets.set_ctest_argument()
else
  " TODO!!
endif

LetIfUndef p:BTW.target = ''
if g:BTW.use_project
  let s:project_config = {
        \ 'type': 'ccmake',
        \ 'arg': lh#ref#bind('p:paths.sources'),
        \ 'wd' : lh#ref#bind('p:BTW.compilation_dir')
        \ }
else
  let s:project_config = {
        \ 'type': 'ccmake',
        \ 'arg': (s:project_sources_dir),
        \ 'wd' : lh#ref#bind('p:BTW.compilation_dir'),
        \ '_'  : g:{s:component_varname}_config
        \ }
endif
call lh#let#if_undef('p:BTW.project_config', s:project_config)

"
" Specialized stuff:
" - tags destination
" - BTW compilation stuff
"


" ======================[ Detect Component {{{2
" I have only one set of configuration files but actually several projects:
" ITK, OTB, and sometimes other proprietary projects that depends on them.
"
let s:component_name = matchstr(s:rel_path_to_current, '[^/\\]*')
let s:component_varname = substitute(s:component_name, '[^a-zA-Z0-9_]', '_', 'g')

let s:opt = { 'name': s:component_name }
call lh#project#define(s:, s:opt, s:component_varname)

call lh#let#to('p:component_name', s:component_name)
call lh#let#to('p:component_varname', s:component_varname)

let s:sources_dir = s:script_dir.'/'.s:component_name

" ======================[ Project config {{{2
if ! (exists("s:loaded_".s:component_varname)
      \ && (g:loaded_ITKnOTB_vimrc_local >= s:k_version)
      \ && !exists('g:force_reload_ITKnOTB_vimrc_local'))
  source <sfile>:p:h/_vimrc_local_global_defs.vim
  let s:loaded_{s:component_varname} = 1
endif

" ======================[ &path {{{2

" No sub project
" let b:project_crt_sub_project = matchstr(lh#path#strip_common([g:{s:component_varname}_config.paths.trunk, expand('%:p:h')])[1], '[^/\\]*[/\\][^/\\]*')

if ! g:BTW.use_project
  " Tells BTW the compilation directory
  call lh#let#to('p:BTW.compilation_dir', g:{s:component_varname}_config.paths._build)
  l
endif

" Local vimrc variable for source dir
" Will be simplified eventually to use p:paths.sources everywhere
if g:BTW.use_project
  let s:project_sources_dir = lh#option#get('paths.sources')
else
  let s:project_sources_dir =  g:{s:component_varname}_config.paths.sources
endif
call lh#let#to('p:project_sources_dir', s:project_sources_dir)

" Option for Mu-Template-> |s:path_from_root()|
" Now: p:paths.sources is enough!

" Used by mu-template to generate file headers and header-gates.
call lh#let#to('p:cpp_included_paths', [s:project_sources_dir])

" If the project has .h.in files that are generated in the build
" directory, uncomment the next line
" let b:cpp_included_paths += [b:BTW_compilation_dir]

" Configures lh-cpp complete includes sub-plugin -> ftplugin/c/c_AddInclude.vim
call lh#let#to('p:includes',
      \ [ s:project_sources_dir . '/**'
      \ , lh#option#get('BTW.compilation_dir') . '/**'])
"      For config.h.in files and alike
"      let b:includes += [lh#option#get(BTW.compilation_dir) . '/**']
" todo: adapt it automatically to the current compilation dir

if SystemDetected() == 'unix'
  " Add your 3rd party libraries used in the project here
  call lh#path#add_path_if_exists('p:includes', $HOME.'/dev/boost/1_51_0/install/include/')
  call lh#path#add_path_if_exists('p:includes', '/usr/local/include/**')
  call lh#path#add_path_if_exists('p:includes', '/usr/include/**')
endif

" Fetch INCLUDED paths from cmake cache configuration, and merge every thing
" into b:includes
function! s:UpdateIncludesFromCmake()
  try
    let included_paths = lh#cmake#get_variables('INCLUDE')
    call filter(included_paths, 'v:val.value!~"NOTFOUND"')
    let uniq_included = {}
    silent! unlet incl
    for incl in values(included_paths)
      let uniq_included[incl.value] = 1
    endfor
    silent! unlet incl
    let includes = lh#option#get('includes') " reference to actual variable!
    for incl in b:includes
      let uniq_included[incl] = 1
    endfor
    let includes = keys(uniq_included)
  catch /.*/
    call lh#common#warning_msg(v:exception)
  endtry
endfunction

" Setting &path
exe 'set path+='.lh#path#fix(lh#option#get('BTW.compilation_dir')).'/**'
" If the project has .h.in files that are generated in the build
" directory, uncomment the next line
" source dir are automatically added thanks to lh-tags v2
for p in lh#option#get('includes')
  if p !~ '^/usr'
    exe 'setlocal path+='.lh#path#fix(p)
  endif
endfor

if 0
  " gcov output path
  let b:gcov_files_path = g:{s:component_varname}_config.paths.sources.'/obj/debug/Testing/CoverageInfo'
endif

" ======================[ tags generation {{{2
" TODO: This may need to be done elsewhere: once per buffer
" Update Vim &tags option w/ the tag file produced for the current project
call lh#tags#update_tagfiles() " uses BTW_project_config

" Instruct to ignore spelling of code constructs
call lh#tags#ignore_spelling()

" ======================[ Project's style {{{2
let s:ns = lh#let#to('p:cpp_project_namespace', tolower(s:component_varname))
" Expecting your project has a Â«project_nsÂ»::Exception type
call lh#let#to('p:exception_type', s:ns.'::Exception')

" Special management of tests and unit tests
if expand('%:p') =~ s:project_sources_dir.'/Testing'
  let b:ipf_dox_group = 'gTests'
  let b:is_unit_test = 1
endif

" ======================[ Settings for searchfile {{{2
let b:searchfile_ext = 'h,H,C,cpp,cxx,hxx,txx'

" ======================[ Menus {{{2
" TODO: fix component varname
call lh#menu#make('nic', '50.11', '&Project.Edit local &CMake file', '<localleader><F7>', '<buffer>', ':call g:{s:component_varname}_config.functions.EditLocalCMakeFile()<cr>')
call lh#menu#make('nic', '50.12', '&Project.Edit local &CMake file (vertical)', '<localleader>v<F7>', '<buffer>', ':call g:{s:component_varname}_config.functions.EditLocalCMakeFile("vert")<cr>')
" call lh#menu#make('nic', '50.11', '&Project.Edit local &Scons file', '', '<buffer>', ':call EditLocalSconsFile()<cr>')
call lh#menu#make('nic', '50.76', '&Project.Edit local &vimrc', '<localleader>le', '<buffer>', ':call lh#buffer#jump('.string(s:script).', "sp")<cr>' )

" ======================[ Local variables to automagically import in QuickFix buffer {{{2
QFImport tags_select
" QFImport &path
" QFImport BTW_project_target
" QFImport BTW_compilation_dir
" QFImport BTW_project_config
" QFImport includes
QFImport b:crt_project

" ======================[ Other commands {{{2
command! -b -nargs=* LVEcho echo <sid>Echo(<args>)

"=============================================================================
" Global Definitions {{{1
" Avoid global reinclusion {{{2
if &cp || (exists("g:loaded_ITKnOTB_vimrc_local")
      \ && (g:loaded_ITKnOTB_vimrc_local >= s:k_version)
      \ && !exists('g:force_reload_ITKnOTB_vimrc_local'))
  let &cpo=s:cpo_save
  finish
endif
let g:loaded_ITKnOTB_vimrc_local = s:k_version
" Avoid global reinclusion }}}2
"------------------------------------------------------------------------

" ======================[ Misc function {{{2
" Function: s:Echo(expr) {{{3
function! s:Echo(expr)
  return a:expr
  " return eval(a:expr)
endfunction
"------------------------------------------------------------------------
" }}}1
"------------------------------------------------------------------------
let &cpo=s:cpo_save
"=============================================================================
" vim600: set fdm=marker:
