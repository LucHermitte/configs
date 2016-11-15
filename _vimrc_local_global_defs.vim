"=============================================================================
" File:         dev/(ITK|OTB)/_vimrc_local.vim  {{{1
" Author:       Luc Hermitte <EMAIL:hermitte {at} c-s {dot} fr>
let s:k_version = 001
" Created:      04th Jun 2015
" Last Update:10th Nov 2016
"------------------------------------------------------------------------
" Description:
"       «description»
"
" }}}1
"=============================================================================

let s:cpo_save=&cpo
set cpo&vim


" ======================[ Global project configuration {{{2
let s:component_name = lh#option#get('component_name')
let s:component_varname = lh#option#get('component_varname')

" 2x:h -> remove file name -> move dir up from .config/
let s:script_dir = expand('<sfile>:p:h:h')
let s:sources_dir = s:script_dir.'/'.s:component_name

" unlet g:{s:component_varname}_config
" Mandatory Project options
if ! g:BTW.use_project
  call lh#let#if_undef('g:'.s:component_varname.'_config.paths.trunk', s:sources_dir)
  call lh#let#if_undef('g:'.s:component_varname.'_config.name',        s:component_varname)
  call lh#let#if_undef('g:'.s:component_varname.'_config.paths.project', fnamemodify(g:{s:component_varname}_config.paths.trunk,':h:h'))
  call lh#let#if_undef('g:'.s:component_varname.'_config.paths.build_root_dir', 'build/'.s:component_name)

  " call lh#let#if_undef('g:'.s:component_varname.'_config.paths.doxyfile', string(g:{s:component_varname}_config.paths.project))

  " Here, this matches all the trunk => complete even with test files
  call lh#let#if_undef('g:'.s:component_varname.'_config.paths.sources', g:{s:component_varname}_config.paths.project.'/src/'.s:component_name)
  " Optional Project options
  call lh#let#if_undef('g:'.s:component_varname.'_config.compilation.mode', 'reldeb')
  call lh#let#if_undef('g:'.s:component_varname.'_config.tests.verbosity', '-VV')

else
  call lh#let#if_undef('p:BTW.config.name', s:component_name)
  call lh#let#if_undef('p:paths.project', fnamemodify(s:sources_dir, ':h:h'))
  call lh#let#if_undef('p:paths.build_root_dir', 'build/'.s:component_name)
  call lh#let#if_undef('p:BTW.build.mode.current', 'reldeb')
  call lh#let#if_undef('p:BTW.tests.verbosity', '-VV')
  " call lh#let#if_undef('p:BTW.tests.test_regex', '')
endif

" ======================[ Menus {{{2
let s:menu_priority = '50.120.'
let s:menu_name     = '&Project.&'.matchstr(s:component_name, 'OTB\|ITK').'.'

" OR!!!
LetIfUndef p:menu.priority = '50.120.'
call lh#let#if_undef('p:menu.name', '&Project.&'.matchstr(s:component_name, 'OTB\|ITK').'.')

" Function: s:getSNR([func_name]) {{{3
function! s:getSNR(...)
  if !exists("s:SNR")
    let s:SNR=matchstr(expand('<sfile>'), '<SNR>\d\+_\zegetSNR$')
  endif
  return s:SNR . (a:0>0 ? (a:1) : '')
endfunction

" Function: s:EditLocalCMakeFile([pos]) {{{3
function! s:EditLocalCMakeFile(...)
  let where = a:0==0 ? '' : a:1.' '
  let file = lh#path#to_relative(expand('%:p:h').'/CMakeLists.txt')
  call lh#buffer#jump(file, where.'sp')
endfunction

if ! g:BTW.use_project
  call lh#let#if_undef ('g:'.s:component_varname.'_config.functions',
        \ {'EditLocalCMakeFile': function(s:getSNR('EditLocalCMakeFile'))})
else
  call lh#let#if_undef ('p:BTW.config.functions',
        \ {'EditLocalCMakeFile': function(s:getSNR('EditLocalCMakeFile'))})
endif

"------------------------------------------------------------------------
" ======================[ Compilation mode, & CTest options {{{2
let g:{s:component_varname}_config_menu = {
      \ '_project': s:component_varname.'_config',
      \ 'menu': {'priority': s:menu_priority, 'name': s:menu_name}
      \ }
call lh#let#to('p:BTW.config.menu', g:{s:component_varname}_config_menu)
if ! g:BTW.use_project
  let s:cmake_integration = []
  let s:cmake_integration += [ 'auto_detect_compil_modes' ]
  " let s:cmake_integration += [ 'def_toggable_compil_mode' ]
  let s:cmake_integration += [ 'def_toggable_ctest_verbosity' ]
  " let s:cmake_integration += [ 'def_toggable_ctest_checkmem' ]
  let s:cmake_integration += [ 'def_ctest_targets' ]
  " let s:cmake_integration += [ 'add_gen_clic_DB' ]
  " let s:cmake_integration += [ 'update_list' ]
  call lh#btw#cmake#def_options(g:{s:component_varname}_config_menu, s:cmake_integration)
else
  let s:cmake_integration = []
  let s:cmake_integration += [ 'auto_detect_compil_modes2' ]
  let s:cmake_integration += [ 'def_toggable_ctest_verbosity2' ]
  let s:cmake_integration += [ 'def_toggable_ctest_checkmem2' ]
  let s:cmake_integration += [ 'def_ctest_targets2' ]
  call lh#btw#cmake#define_options(s:cmake_integration)
endif


" ======================[ Misc functions {{{2
" }}}1
"------------------------------------------------------------------------
let &cpo=s:cpo_save
"=============================================================================
" vim600: set fdm=marker:
