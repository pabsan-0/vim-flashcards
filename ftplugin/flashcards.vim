" Use formatexpr to apply SmartIndent on auto-wrapped lines
setlocal textwidth=50

function! FlashcardsAlignSeparator()
    let l:separator_length = 50
    execute 'g/^=\+$/s/.*/\=repeat("=", ' ..  l:separator_length .. ')/'
endfunction

function! FlashcardsAlignDate()
    " Define target column for date alignment
    let target_column = 50

    " Loop over each line in the buffer
    for lnum in range(1, line('$'))
        
        " Match lines with 'FLASHCARD <number> <date>'
        let line = getline(lnum)
        if line =~# '^[A-Z ]\+\d\+\s\{2,}\d\+-[a-zA-Z0-9]\+-\d\{2,4}'
              
            " Extract the components
            let left_part = matchstr(line, '^[A-Z ]\+\d\+')
            let date_part = matchstr(line, '\d\+-[a-zA-Z0-9]\+-\d\{2,4}')

            " Calculate spaces needed to align date at target column
            let spaces_needed = target_column - len(left_part) - len(date_part)

            " Build the new aligned line
            let new_line = left_part . repeat(' ', spaces_needed) . date_part

            " Set the new line in the buffer
            call setline(lnum, new_line)
            
        endif
    endfor
endfunction

function! FlashcardsAlignTips()
    
    " Measure length of largest sentence before '  : '
    let l:maxlen = 0
    for line in getline(1, '$')
        if line =~ ' : '
            let pre_colon_text = matchstr(line, '^\(.*\S\)\ze\s\+:')
            let maxlen = max([l:maxlen, strlen(pre_colon_text)])
        endif
    endfor

    " Custom offset
    let l:maxlen += 1

    " Format lines by aligning colons
    execute '%s/\v(.*\S)+\s*:\s*/\=printf("%-' .. l:maxlen .. 's : ", submatch(1))/'

endfunction

" Apply formatting on save
function! FlashcardsAlign()
    call FlashcardsAlignSeparator()
    call FlashcardsAlignDate()
    call FlashcardsAlignTips()
endfunction

autocmd BufWritePre <buffer> call FlashcardsAlign()
