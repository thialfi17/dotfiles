augroup Commands
    au!
    au! BufEnter <buffer> :call SetTextOptions()
    au! BufLeave <buffer> :call clearmatches()
augroup END
