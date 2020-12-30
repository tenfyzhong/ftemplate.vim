if v:version < 800
    echohl WarningMsg | echo 'plugin ftemplate.vim needs Vim version >= 7' | echohl None
    finish
endif

if exists("g:ftemplate_version") 
    finish
endif
let g:ftemplate_version = "1.0.0"
lockvar g:ftemplate_version

augroup file_template
    au!
    autocmd BufNewFile * call ftemplate#insert()
augroup END

let s:root = expand('<sfile>:p:h:h')

function! s:complete(A, L, P)
  let templates = s:root . '/templates/'
  if exists('g:ftemplate_local_templates') && isdirectory(expand(g:ftemplate_local_templates, ':p'))
    let templates = templates . ',' . g:ftemplate_local_templates
  endif
  let ftls = globpath(templates, '*.ftl', 0, 1)
  call map(ftls, 'fnamemodify(v:val, ":p:t:r")')
  call filter(ftls, 'v:val =~ "^".a:A')
  call filter(ftls, 'count(ftls, v:val) == 1')
  return ftls
endfunction

command! -nargs=? -complete=customlist,<SID>complete Ftemplate call ftemplate#insert(<q-args>)
