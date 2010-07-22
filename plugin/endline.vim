" ============================================================================
" File: endline.vim
" Description: Easily add filetype-specific line-endings.
" Maintainer: Thomas Allen <thomasmallen@gmail.com>
" ============================================================================
let s:EndlineVersion = '0.1'

" Insert a line ending if it exists
function! g:EndlineAdd(char)
  let line = getline('.')
  if match(line, '\V' . escape(a:char, '\') . '\v\s*$') == -1
    exec 'normal A' . a:char
  endif
endfunction

function! s:mapLineEnders(ft, char)
  if g:EndlineInsert
    exec 'au FileType ' . a:ft . " inoremap <buffer> "
          \. g:EndlineInsertMapping . " <ESC>:call g:EndlineAdd('"
          \. a:char . "')<CR>a<CR>"
  endif

  if g:EndlineNormal
    exec 'au FileType ' . a:ft . " nnoremap <buffer> "
          \. g:EndlineNormalMapping . " :call g:EndlineAdd('"
          \. a:char . "')<CR>"
  endif
endfunction

function! s:mapFtLineEnders(ftMap)
  for ft in keys(a:ftMap)
    call s:mapLineEnders(ft, a:ftMap[ft])
  endfor
endfunction

function! s:Set(var, val)
  if !exists(a:var)
    exec 'let ' . a:var . ' = ' . string(a:val)
  end
endfunction

call s:Set('g:EndlineMapping', '<S-CR>')
call s:Set('g:EndlineInsertMapping', g:EndlineMapping)
call s:Set('g:EndlineNormalMapping', g:EndlineMapping)
call s:Set('g:EndlineInsert', 1)
call s:Set('g:EndlineNormal', 1)
call s:Set('g:Endlines', {})

call s:mapFtLineEnders(g:Endlines)
