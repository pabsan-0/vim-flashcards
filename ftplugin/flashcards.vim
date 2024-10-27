setlocal textwidth=65

function! FlashcardsAlignSeparator()
    execute 'g/^=\+$/s/.*/\=repeat("=", ' .. &textwidth  .. ')/'
endfunction

function! FlashcardsAlignDate()
    for lnum in range(1, line('$'))
        let line = getline(lnum)

        if line =~# '^[A-Z ]\+\d\+\s\{2,}\d\+-[a-zA-Z0-9]\+-\d\{2,4}'
            let left_part = matchstr(line, '^[A-Z ]\+\d\+')
            let date_part = matchstr(line, '\d\+-[a-zA-Z0-9]\+-\d\{2,4}')

            let spaces_needed = &textwidth - len(left_part) - len(date_part)
            let new_line = left_part . repeat(' ', spaces_needed) . date_part
            call setline(lnum, new_line)
        endif

    endfor
endfunction

function! FlashcardsAlignTips()
    let l:maxlen = 0
    
    " Measure length of largest sentence before '  : '
    for line in getline(1, '$')
        if line =~ ' : '
            let pre_colon_text = matchstr(line, '^\(.*\S\)\ze\s\+:')
            let maxlen = max([l:maxlen, strlen(pre_colon_text)])
        endif
    endfor

    " Format lines by aligning colons, apply offset
    execute '%s/\v(.*\S)+\s*:\s*/\=printf("%-' .. (l:maxlen+1) .. 's : ", submatch(1))/'

endfunction


" Apply formatting on save
function! FlashcardsAlign()
    " Save the current cursor position
    let l:save_cursor = getpos(".")

    call FlashcardsAlignSeparator()
    call FlashcardsAlignDate()
    call FlashcardsAlignTips()

    call setpos('.', l:save_cursor)
endfunction

autocmd BufWritePre <buffer> call FlashcardsAlign()
