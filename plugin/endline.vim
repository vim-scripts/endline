" ============================================================================
" File: endline.vim
" Description: Easily add filetype-specific line-endings.
" Maintainer: Thomas Allen <thomas@oinksoft.com>
" Version: 0.2.0
" ============================================================================

function! EndlineAdd(ft)
  let line = getline('.')
  let mapping = get(g:Endlines, a:ft)
  if type(mapping) == type([])
    for [patt, ending] in mapping
      if match(line, patt) != -1
            \&& match(line, '\V' . escape(ending, '\') . '\v\s*$') == -1
        exec 'normal A' . ending
        break
      endif
    endfor
  elseif match(line, '\V' . escape(mapping, '\') . '\v\s*$') == -1
    exec 'normal A' . mapping
  endif
endfunction

function! s:mapLineEnders(ft, char)
  if g:EndlineInsert
    exec 'au FileType ' . a:ft . ' inoremap <buffer> '
          \. g:EndlineInsertMapping . " <ESC>:call EndlineAdd('" . a:ft
          \. "')<CR>a<CR>"
  endif

  if g:EndlineNormal
    exec 'au FileType ' . a:ft . " nnoremap <buffer> "
          \. g:EndlineNormalMapping . " :call EndlineAdd('" . a:ft
          \. "')<CR>"
  endif
endfunction

function! EndlineRemap()
  for ft in keys(g:Endlines)
    call s:mapLineEnders(ft, g:Endlines[ft])
  endfor
endfunction

function! s:set(var, val)
  if !exists(a:var)
    exec 'let ' . a:var . ' = ' . string(a:val)
  end
endfunction

call s:set('g:EndlineMapping', '<S-CR>')
call s:set('g:EndlineInsertMapping', g:EndlineMapping)
call s:set('g:EndlineNormalMapping', g:EndlineMapping)
call s:set('g:EndlineInsert', 1)
call s:set('g:EndlineNormal', 1)
call s:set('g:Endlines', {})

command! EndlineRemap call EndlineRemap()

call EndlineRemap()
