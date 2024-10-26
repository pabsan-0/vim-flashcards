
function! FlashcardsAlign()
    
    " Measure length of largest sentence before '  : '
    let l:maxlen = 0
    for line in getline(1, '$')
        if line =~ ' : '
            let pre_colon_text = matchstr(line, '^\(.*\S\)\ze\s\+:')
            let maxlen = max([maxlen, strlen(pre_colon_text)])
        endif
    endfor

    " Custom offset
    let l:maxlen += 1

    " Format lines by aligning colons
    execute '%s/\v(.*\S)+\s*:\s*/\=printf("%-' .. l:maxlen .. 's : ", submatch(1))/'

endfunction

" Apply formatting on save
autocmd BufWritePre <buffer> call FlashcardsAlign()
