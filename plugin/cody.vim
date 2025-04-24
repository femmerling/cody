function! s:CodyInlineComment(start, end)
  execute a:start . "," . a:end . "y"
  let prompt = getreg('"')
  let s:plugin_root = expand('<sfile>:p:h:h') " Goes two levels up: from plugin/ to root
  let s:script_path = s:plugin_root . '/scripts/cody-to-buffer.sh'
  let response = system("echo ".shellescape(prompt)." | " . shellescape(s:script_path) . " | xargs cat")

  let lines = split(response, "\n")

  let comment_prefix = '// '
  if &filetype ==# 'python'
    let comment_prefix = '# '
  elseif &filetype ==# 'lua'
    let comment_prefix = '-- '
  elseif &filetype ==# 'vim'
    let comment_prefix = '" '
  endif

  let comment_lines = map(lines, 'comment_prefix . v:val')

  call append(a:end, comment_lines)
endfunction

command! -range=% AskCody call s:CodyInlineComment(<line1>, <line2>)

if !exists('g:cody_no_maps')
  vnoremap <silent> <leader>ai :AskCody<CR>
endif
