" Regex samples
"
" hello
" hello world
" lello wijilj    asjkdkjansdjkfnjkn kjn
" hello


" Match least amount of text followed by at least 3 spaces in first line
syntax match FirstLineTitle "\%1l^.\{-}\ze\(\s\s\s\|\n\)"

" Match any text preceded by 3 spaces in first line
syntax match FirstLineDesc  "\%1l\s\s\s\zs.*"

" Match a line with only = characters
syntax match Separator  "^=\+$"

