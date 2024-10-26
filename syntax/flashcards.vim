syntax match FlashcardFirstLineTitle   "\%1l^.\{-}\ze\(\s\s\s\|\n\)"     " Match least amount of text followed by at least 3 spaces in first line
syntax match FlashcardFirstLineDesc    "\%1l\s\s\s\zs.*"                 " Match any text preceded by 3 spaces in first line
syntax match FlashcardSeparator        "^=\+$"                           " Match a line with only = characters
syntax match FlashcardCollectionNumber "^[A-Z]\+\s*\d\+"                 " Match uppercase letters followed by a number
syntax match FlashcardDate             "\d\+-[a-zA-Z0-9-]\+-\d\{2,4}"    " Match date at EOL after CollectionNumber
syntax match FlashcardTitle            "^[A-Z][a-zA-Z ]*$"               " Match any Word or Sentence plus newline
syntax match FlashcardInfolineLeft     ".*\ze\s\s\+:\s\+.*$"               " Match any : and take left side 
syntax match FlashcardInfolineRight    ".*\zs\s\s\+:\s\+.*$"               " March any : and take right side

highlight FlashcardFirstLineTitle   ctermfg=Red         cterm=bold
highlight FlashcardFirstLineDesc    ctermfg=Gray
highlight FlashcardSeparator        ctermfg=DarkMagenta cterm=bold
highlight FlashcardCollectionNumber ctermfg=Yellow      cterm=bold
highlight FlashcardDate             ctermfg=Red 
highlight FlashcardTitle            ctermfg=DarkMagenta cterm=bold
highlight FlashcardInfolineLeft     ctermfg=Cyan        cterm=bold
highlight FlashcardInfolineRight    ctermfg=White
