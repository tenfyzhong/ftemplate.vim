let s:template_dir = expand('<sfile>:p:h:h') . '/templates/'

function! ftemplate#insert(...)
  if a:0 > 0
    let ft=a:1
  else
    let ft=&ft
  endif
  let lines = <SID>get_template(ft)
  if len(lines) == 0 
    return
  endif

  let macros = <SID>get_macro()
  let rendered = []
  for line in lines
    let line = <SID>render_macro(line, macros)
    let line = <SID>render_cmd(line)
    call add(rendered, line)
  endfor

  call append(0, rendered)
  set modified
endfunction

function! s:get_ftl(ft)
  if exists('g:ftemplate_local_templates')
    let path = fnamemodify(g:ftemplate_local_templates, ':p')
    let file = path . a:ft . '.ftl'
    if filereadable(file)
      return file
    endif
  endif

  let file = s:template_dir . a:ft . '.ftl'
  if filereadable(file)
    return file
  endif

  return ''
endfunction

function! s:get_template(ft)
  let file = <SID>get_ftl(a:ft)
  if file == ''
    return []
  endif
  let lines = readfile(file)
  return lines
endfunction

function! s:get_macro()
  let macro = {}
  let env = environ()
  call filter(env, 'v:key =~ "^FT_VIM_"')
  for k in keys(env)
    let key = substitute(k, '^FT_VIM_\(.*\)', '\1', '')
    let value = get(env, k, '')
    let macro[key] = value
  endfor
  return macro
endfunction

function! s:render_macro(line, macro)
  let line = a:line
  for key in keys(a:macro)
    let pattern = '{' . key . '}'
    let line = substitute(line, pattern, a:macro[key], 'g')
  endfor
  return line
endfunction

function! s:render_cmd(line)
    let [cmd, start, end] = matchstrpos(a:line, '`[^`]*`')
    if cmd != ''
      let output = trim(<SID>eval(cmd[1:-2]))
      if output != ''
        let nline = ''
        if start > 0
          let nline = a:line[:start-1]
        endif
        let nline = nline . output
        if end < len(a:line)
          let nline = nline . a:line[end:]
        endif
        return <SID>render_cmd(nline)
      endif
    endif
    return a:line
endfunction

function! s:eval(cmd)
  if a:cmd =~# '^!v '
    let cmd = a:cmd[3:]
    try
      let out = eval(cmd)
      return out
    catch /.*/
      echoerr v:exception
      return ''
    endtry
  else
    return system(a:cmd)
  endif
  return ''
endfunction
