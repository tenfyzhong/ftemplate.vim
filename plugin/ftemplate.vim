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
    autocmd BufNewFile * call ftemplate#insert(&ft)
augroup END

command! -nargs=0 Ftemplate call ftemplate#insert(&ft)
