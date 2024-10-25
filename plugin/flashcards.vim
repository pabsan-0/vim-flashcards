let g:flashcards_directory = "/opt/pabsan-0/flashcards/cards/"
let g:flashcards_template = "/opt/pabsan-0/flashcards/assets/template.fc"
let s:flashcards_echom_prefix = '[flashcards.vim] '

" Check that fzf.vim is installed
if match(&runtimepath, 'fzf.vim') == -1
    echom s:flashcards_echom_prefix . "fzf.vim not found! Loading anyway, do expect issues." 
endif

" Main calls to FZF and Rg
" Within functions to enable tab-switching without code duplication
function! s:flashcard_call_rg(query)
    call fzf#vim#grep(
        \ "rg --column --color=always --smart-case " . shellescape(a:query), 
        \ 1, 
        \ fzf#vim#with_preview({'dir': g:flashcards_directory, 
        \   'options': ['--expect=alt-enter,tab,ctrl-t','--query', a:query], 
        \   'sink*': function('s:flashcard_cb_rg')
        \ }), 0)
endfunction

function! s:flashcard_call_fzf(query)
    call fzf#vim#files(g:flashcards_directory, fzf#vim#with_preview({
        \   'options': ['--expect=alt-enter,tab,ctrl-t','--query', a:query], 
        \   'sink*': function('s:flashcard_cb_fzf')
        \ }), 0)
endfunction


" User interfaces to the functions above
command! -bang -nargs=* FlashcardsFzf
    \ call s:flashcard_call_fzf(<q-args>)

command! -bang -nargs=* FlashcardsRg
    \ call s:flashcard_call_rg(<q-args>)


" This function switches FZF<->RG while keeping the current buffered text
" - Depends on g:fzf_history_dir to be configured
" - Not perfect: won't usually crash everything but shows weird behavior
function! s:flashcard_mode_switch(current_mode)

    if a:current_mode == 'fzf'
        let l:history = readfile(expand(g:fzf_history_dir) . "/files", '', -1)
        let l:last = l:history[0]
        call s:flashcard_call_rg(l:last)
    elseif a:current_mode == 'rg'
        let l:history = readfile(expand(g:fzf_history_dir) . "/rg", '', -1)
        let l:last = l:history[0]
        call s:flashcard_call_fzf(l:last)
    else
        echom s:flashcards_echom_prefix . 'Wrong current mode argument.'
    endif

endfunction


" Three fzf.vim callbacks: 2 specific + 1 common one
" This is to know current mode towards switching FZF<->RG
" After this check is made, the whole logic off the fzf menu begins
function! s:flashcard_cb_rg(lines)
    call s:flashcard_cb(a:lines, "rg")
endfunction

function! s:flashcard_cb_fzf(lines)
    call s:flashcard_cb(a:lines, "fzf")
endfunction

function! s:flashcard_cb(lines, current_mode)

    if len(a:lines) < 2
        let l:key = a:lines[0]
        let l:file = 0
    else
        let [l:key, l:fileline_str] = a:lines
        let l:file = split(l:fileline_str, ':', 2)[0]
    endif

	if key == 'tab' "TODO edge case where there is no match
        call s:flashcard_mode_switch(a:current_mode)
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
       " default behavior: do nothing 
    endif
endfunction


" Key mapping to invoke an entrypoint, only if not being used already
if mapcheck("<leader>c", "I") == "" 
    nnoremap <leader>c :FlashcardsRg <CR>
endif
