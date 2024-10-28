" Autogroup is automatically created by vim on ftdetect/* files
au! BufNewFile,BufRead *.fc  " Remove shadowing ft rule from newer vim versions: /usr/share/vim/vim91/filetype.vim
au  BufNewFile,BufRead *.fc setfiletype flashcards
