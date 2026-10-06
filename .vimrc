set nocompatible
syntax on

set background=dark
silent! colorscheme default

set nowrap
set fillchars=diff:╱,vert:│
set diffopt=internal,filler,closeoff,indent-heuristic,algorithm:histogram

" Diff highlights use the terminal ANSI palette.
highlight DiffAdd    ctermfg=0 ctermbg=2 cterm=NONE
highlight DiffDelete ctermfg=1 ctermbg=NONE cterm=NONE
highlight DiffChange ctermfg=0 ctermbg=4 cterm=NONE
highlight DiffText   ctermfg=0 ctermbg=3 cterm=bold
