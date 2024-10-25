# flashcards.vim

Vim integration of flashcards - quick sticky notes with useful tips.

## Installation

This plugin requires you to have [fzf.vim](https://github.com/junegunn/fzf.vim) first, as well as `batcat`.

Using vim-plug:

```
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'pabsan-0/vim-flashcards'
```

Installing batcat:
```
$ sudo apt install bat
```

## Setup 

You'll need a flashcard collection to draw from. These could be simple text files, but I have opted for using a custom `.fc` format. Find my collection at [pabsan-0/flashcards](https://github.com/pabsan-0/flashcards).

## Usage 

If unused, the plugin will set `<leader>c` as default mapping to call the flashcards view.

The point of this plugin is speed, nonetheless you can also call it via the slower `:FlashcardsRg` and `:FlashcardsFzf`. 


## FTplugin

TODO

