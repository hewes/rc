let g:my_debugger = {'logs' : []}
function! g:my_debugger.log(str) dict
  call add(self.logs, a:str)
endfunction

function! g:my_debugger.result_of(cmd) dict
  call self.log('result of '. a:cmd)
  redir => result
  silent execute a:cmd
  redir END
  call self.log(result)
endfunction

function! g:my_debugger.clear() dict
  let self.logs = []
endfunction

function! g:my_debugger.output() dict
  if empty(self.logs) | return | endif
  try
    redir >> ~/.vim/debugging.log
    for msg in self.logs
      silent echo msg
    endfor
  finally
    redir END
    call self.clear()
  endtry
endfunction

command! -nargs=1 MyDebug call g:my_debugger.log(<q-args>)
command! OutputMyDebug call g:my_debugger.output()
command! ClearMyDebug call g:my_debugger.clear()

