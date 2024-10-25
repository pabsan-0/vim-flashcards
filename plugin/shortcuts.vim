let s:flashcards_echom_prefix = '[flashcards.vim] '
let g:flashcards_directory = "/opt/pabsan-0/flashcards/cards/"
let g:flashcards_template = "/opt/pabsan-0/flashcards/assets/template.fc"

" Check that fzf.vim is installed
if match(&runtimepath, 'fzf.vim') == -1
    echom s:flashcards_echom_prefix . "fzf.vim not found! Loading anyway, do expect issues." 
endif

" TODO decide functionalities
" TODO initial query to be able to switch modes



" These functions are used to alternate the history used when 
" switching from one mode to the other.
function! s:flashcard_cb_rg(lines)
    call s:flashcard_cb(a:lines, "rg")
endfunction

function! s:flashcard_cb_fzf(lines)
    call s:flashcard_cb(a:lines, "fzf")
endfunction


function! s:flashcard_cb(lines, mode)

    if len(a:lines) < 2
        let l:key = a:lines[0]
        let l:file = 0
    else
        let [l:key, l:fileline_str] = a:lines
        let l:file = split(l:fileline_str, ':', 2)[0]
    endif

	if key == 'tab' "TODO edge case where there is no match

        if a:mode == 'fzf'
            let l:history = readfile(expand(g:fzf_history_dir) . "/files", '', -1)
            let l:last = l:history[0]
            call fzf#vim#grep(
                \ "rg --column --color=always --smart-case ' '", 
                \ 1, 
                \ fzf#vim#with_preview({'dir': g:flashcards_directory, 
                \   'options': ['--expect=alt-enter,tab,ctrl-t','--query', l:last], 
                \   'sink*': function('s:flashcard_cb_rg')
                \ }), 0)

        elseif a:mode == 'rg'
            let l:history = readfile(expand(g:fzf_history_dir) . "/rg", '', -1)
            let l:last = l:history[0]
            call fzf#vim#files(g:flashcards_directory, fzf#vim#with_preview({
                \   'options': ['--expect=alt-enter,tab,ctrl-t','--query', l:last], 
                \   'sink*': function('s:flashcard_cb_fzf')
                \ }), 0)

        return
    endif

    if l:file == 0
        return
    endif

    if key == 'alt-enter' "TODO
        execute 'tabedit' g:flashcards_directory .. file

    elseif key == 'ctrl-n' "TODO
        execute 'tabedit' g:flashcards_directory .. file

    elseif key == 'ctrl-t' "TODO
        execute 'tabedit' g:flashcards_directory .. file
		execute 'tabp'

    elseif key == 'ctrl-w' "TODO
        execute 'tabedit' g:flashcards_directory .. file
		execute 'tabp'
    else
            echom "Wrong a:mode argument"
        endif
    else
       " default behavior: do nothing 
    endif
endfunction

command! -bang -nargs=* FlashcardsFzf
    \ call fzf#vim#files(g:flashcards_directory, fzf#vim#with_preview({
    \   'options': ['--expect=ctrl-r,alt-enter,tab,ctrl-t'], 
    \   'sink*': function('s:flashcard_cb_fzf')
    \ }), <bang>0)

command! -bang -nargs=* FlashcardsRg
    \ call fzf#vim#grep(
    \ "rg --column --color=always --smart-case ".shellescape(<q-args>), 
    \ 1, 
    \ fzf#vim#with_preview({'dir': g:flashcards_directory, 
    \   'options': ['--expect=ctrl-r,alt-enter,tab,ctrl-t'], 
    \   'sink*': function('s:flashcard_cb_rg')
    \ }),
    \ <bang>0)


" Key mapping to invoke the Action command, only if not being used
if mapcheck("<leader>c", "I") == "" 
    nnoremap <leader>c :FlashcardsRg <CR>
endif
