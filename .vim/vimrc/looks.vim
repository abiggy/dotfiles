" Stuff having to do with looks go here

if has("gui_running")
" GUI ================
  "colors sienna
  "colors zenburn
  "colors lucius
  colors jellybeans
  " colors badwolf
  set lines=70
  set columns=130
  " Remove scrollbars, toolbars, etc.
  set guioptions-=L
  set guioptions-=r
  set guioptions-=T

  if has("gui_gtk2")
    set guifont=Monaco\ 12
  elseif has("gui_win32")
    set guifont=Monaco:h10:cANSI
  else
    set guifont=Monaco:h12
  endif
else
" TERMINAL ===========
  " for default color scheme
  set background=dark

  if $SSH_CONNECTION == ""  " Local terminal
    set t_Co=256
  else            " Remote terminal
    "set t_Co=16
    set t_Co=256
  endif

  if &term == "screen-bce"  " Running in screen
    set ttymouse=xterm2
  endif

  "colors zenburn
  "colors lucius
  colors jellybeans
endif

if exists('+colorcolumn')
  hi ColorColumn ctermbg=235 guibg=#2C2D27
  set colorcolumn=100
endif

" Molokai Original
colorscheme molokai
"let g:molokai_original = 1
let g:rehash256 = 1

" Hybrid theme
"let g:hybrid_use_iTerm_colors = 1
" colorscheme hybrid

" Vimbrant theme
"set background=dark
"colorscheme vimbrant
"highlight ColorColumn ctermbg=7
"highlight ColorColumn guibg=Gray

