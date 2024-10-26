
function! b:FlashcardsLoadTemplate ()
    read
endfunction

function! b:FlashcardsFormatting ()
    " Ideas
    " Set the title indentation to zero
    " Set the description to the right of the title
    
    " Ensure the separator '===' is there and adjust its lenght
    
    " Maybe do this if we're on an unsaved buffer
    " Detect the template empty fields for FLASHCARD XX and XX-XX-XXXX, overwrite if so
    
    " Warn the user:
    "   - too wide a note
    
    " Auto align by :

endfunction

" " Apply formatting on save
" autocmd BufWritePre <buffer> call b:flashcard_beautify()
