set nocompatible
syntax on

if has('termguicolors')
  set termguicolors
endif

set background=dark
silent! colorscheme habamax

set nowrap
set fillchars=diff:╱,vert:│
set diffopt=internal,filler,closeoff,indent-heuristic,algorithm:histogram

" Muted, high-readability diff highlights to match the dark palette.
highlight DiffAdd    guifg=NONE    guibg=#1e3326 gui=NONE
highlight DiffDelete guifg=#5c3030 guibg=#331e1e gui=NONE
highlight DiffChange guifg=NONE    guibg=#26303d gui=NONE
highlight DiffText   guifg=NONE    guibg=#3a5066 gui=bold
