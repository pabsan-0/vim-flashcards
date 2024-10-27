syntax match FlashcardsFirstLineTitle   "\%1l^.\{-}\ze\(\s\s\s\|\n\)"     " Match least amount of text followed by at least 3 spaces in first line
syntax match FlashcardsFirstLineDesc    "\%1l\s\s\s\zs.*"                 " Match any text preceded by 3 spaces in first line
syntax match FlashcardsSeparator        "^=\+$"                           " Match a line with only = characters
syntax match FlashcardsCollectionNumber "^[A-Z ]\+\d\+"                 " Match uppercase letters followed by a number
syntax match FlashcardsDate             "\d\+-[a-zA-Z0-9-]\+-\d\{2,4}"    " Match date at EOL after CollectionNumber
syntax match FlashcardsTitle            "^[A-Z][a-zA-Z ]*$"               " Match any Word or Sentence plus newline
syntax match FlashcardsInfolineLeft     ".*\ze\s\s\+:\s\+.*$"               " Match any : and take left side 
syntax match FlashcardsInfolineRight    ".*\zs\s\s\+:\s\+.*$"               " March any : and take right side

highlight FlashcardsFirstLineTitle   ctermfg=Red         cterm=bold
highlight FlashcardsFirstLineDesc    ctermfg=Gray
highlight FlashcardsSeparator        ctermfg=DarkMagenta cterm=bold
highlight FlashcardsCollectionNumber ctermfg=Yellow      cterm=bold
highlight FlashcardsDate             ctermfg=Red 
highlight FlashcardsTitle            ctermfg=DarkMagenta cterm=bold
highlight FlashcardsInfolineLeft     ctermfg=Cyan        cterm=bold
highlight FlashcardsInfolineRight    ctermfg=White
