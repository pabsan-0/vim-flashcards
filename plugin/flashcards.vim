" Symlink-proof way to resolve the plugin's path
let g:flashcards_plugin_path = fnamemodify(resolve(expand('<sfile>:p')), ':h')

" User should tune these options
let g:flashcards_template = g:flashcards_plugin_path .. "/../samples/template.fc"
let g:flashcards_directory = "/opt/pabsan-0/flashcards/cards/"
let g:flashcards_file_extension = '.fc'

" These need mindful tuning, keys need to be changed somewhere else too
let s:flashcards_fzf_keys = 'tab,ctrl-a,ctrl-t,ctrl-l,ctrl-w'
let s:flashcards_fzf_hint = 'switch mode <tab>, add new <C-a>, open on tab <C-t>/<C-l>, open on window <C-w>'
let s:flashcards_echom_prefix = '[flashcards.vim] '


" Pre-checks: fzf installed && user-configured paths exist
if match(&runtimepath, 'fzf.vim') == -1
    echom s:flashcards_echom_prefix . "fzf.vim not found! Loading anyway, do expect issues." 
endif

if !isdirectory(g:flashcards_directory)
    echom s:flashcards_echom_prefix . "Could not find flashcards directory set in g:flashcards_directory: " . g:flashcards_directory
endif

if !filereadable(g:flashcards_template)
    echom s:flashcards_echom_prefix . "Could not find template to load as per  g:flashcards_template: " . g:flashcards_template
endif


" Main calls to FZF and Rg
" Within functions to enable tab-switching without code duplication
function! s:flashcard_call_rg(query)
    call fzf#vim#grep(
        \ "rg --column --color=always --smart-case " .. shellescape(a:query), 
        \ 1, 
        \ fzf#vim#with_preview({'dir': g:flashcards_directory, 
        \   'options': [
        \      '--expect=' .. s:flashcards_fzf_keys,
        \      '--header=' .. s:flashcards_fzf_hint,
        \      '--query', a:query
        \   ], 
        \  'sink*': function('s:flashcard_cb_rg')
        \ }), 0)
endfunction

function! s:flashcard_call_fzf(query)
    call fzf#vim#files(g:flashcards_directory, fzf#vim#with_preview({
        \   'options': [
        \      '--expect=' .. s:flashcards_fzf_keys,
        \      '--header=' .. s:flashcards_fzf_hint,
        \      '--query', a:query
        \   ], 
        \   'sink*': function('s:flashcard_cb_fzf')
        \ }), 0)
endfunction


" User interfaces to the functions above
command! -bang -nargs=* FlashcardsFzf
    \ call s:flashcard_call_fzf(<q-args>)

command! -bang -nargs=* FlashcardsRg
    \ call s:flashcard_call_rg(<q-args>)


" This function switches FZF<->RG while keeping the current buffered text
" - Can only keep text if g:fzf_history_dir is configured, else discards it
" - Not perfect: won't usually crash everything but shows weird behavior
function! s:flashcard_mode_switch(current_mode)

    if a:current_mode == 'fzf'

        if get(g:, 'fzf_history_dir', 0) == 0
            call s:flashcard_call_rg('')
        else
            let l:history = readfile(expand(g:fzf_history_dir) .. "/files", '', -1)
            let l:last = l:history[0]
            call s:flashcard_call_rg(l:last)
        endif

    elseif a:current_mode == 'rg'
        
        if get(g:, 'fzf_history_dir', 0) == 0
            call s:flashcard_call_fzf('')
        else
            let l:history = readfile(expand(g:fzf_history_dir) .. "/rg", '', -1)
            let l:last = l:history[0]
            call s:flashcard_call_fzf(l:last)
        endif
    else
        echom s:flashcards_echom_prefix .. 'Wrong current mode argument.'
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
    
    " If there is a match, lines will have [key, match]
    " Else, it is just [key]
    if len(a:lines) < 2
        let l:key = a:lines[0]
        let l:file = "NONE"
    else
        let [l:key, l:fileline_str] = a:lines
        let l:file = split(l:fileline_str, ':', 2)[0]
    endif

    " Actions that require no match
	if l:key == 'tab'         " Perform mode switching based on the key
        call s:flashcard_mode_switch(a:current_mode)
        return
    elseif l:key == 'ctrl-a'    " Edit and Add a new flashcard
        let l:newcard = input('Insert new filename (no extension): ')
        let l:newcard = l:newcard .. g:flashcards_file_extension
        execute 'tabnew ' .. fnameescape(g:flashcards_directory .. l:newcard)
        execute '0read ' .. fnameescape(g:flashcards_template)
        return
    endif

    " Actions that require match. Ensure sane input before that
    if l:file == "NONE" " Beware! In some versions of vim 'any_str'==0 yields true
        echom s:flashcards_echom_prefix .. 'Empty line selected. No FZF match.'
        return
    endif

    if l:key == 'ctrl-t'        " Open flashcard in a new Tab 
        execute 'tabedit' g:flashcards_directory .. file
        return

    elseif l:key == 'ctrl-l'    " Open flashcard in a new tab for Later
        execute 'tabedit' g:flashcards_directory .. file
		execute 'tabp'
        return

    elseif l:key == 'ctrl-w'    " Open flashcard in new Window
        echo "Specify window split direction: s/v"
        let l:window_split_char = getchar()

        if l:window_split_char ==# 's'
            execute 'split ' .. file
        elseif if l:window_split_char ==# 'v'
            execute 'vsplit ' .. file
        else
            execute 'vsplit ' .. file
        endif
        return 

    else
       " Default behavior: do nothing 
       " This is mainly a visualization app
    endif

endfunction


" Key mapping to invoke an entrypoint, only if not being used already
if mapcheck("<leader>c", "I") == "" 
    nnoremap <leader>c :FlashcardsRg <CR>
endif
