let s:flashcards_echom_prefix = '[flashcards.vim] '
let g:flashcards_directory = "/opt/pabsan-0/flashcards/cards/"
let g:flashcards_template = "/opt/pabsan-0/flashcards/assets/template.fc"

" Check that fzf.vim is installed
if match(&runtimepath, 'fzf.vim') == -1
    echom s:flashcards_echom_prefix . "fzf.vim not found! Loading anyway, do expect issues." 
endif

" TODO sticky flashcards when pressing enter
" TODO Handle different envents
" TODO ftplugin

function! s:fc_rg_file_read(location)
    let string_list = split(a:location, ':', 2)
    execute 'read ' .. g:flashcards_directory .. string_list[0]
endfunction

function! s:flashcard_read(location)
endfunction

function! s:flashcard_create(location)
endfunction


command! -bang -nargs=* Flashcards
    \ call fzf#vim#grep(
    \ "rg -m 1 -L --column --no-heading --pretty --smart-case ".shellescape(<q-args>), 
    \ 1, 
    \ fzf#vim#with_preview({'dir': g:flashcards_directory, 'sink': function('s:fc_rg_file_read')}),
    \ <bang>0)


" Key mapping to invoke the Action command, only if not being used
if mapcheck("<leader>c", "I") == "" 
    nnoremap <leader>c :Flashcards <CR>
endif
