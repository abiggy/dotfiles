" All the Vim settings go here!

set autoindent                        " always set autoindenting on
set autoread                          " Refresh buffer if file has been changed externally. Note that this doesn't automatically run every some interval.
set autowrite                         " Automatically save before commands like :next
set backspace=indent,eol,start        " Backspace over everything.
set cursorline                        " highlight cursor line
set diffopt+=vertical                 " make gdiff vertical instead of horizontal
set encoding=utf8
set expandtab                         " always uses spaces instead of tab characters
set foldlevel=20
"set foldmethod=Syntax                 makes 7.4 almost unusable slow e.g. for js&ruby files
set foldmethod=indent                 " Works much better for js files. @TODO Slow?
set nofoldenable                      " disable folding
set formatoptions=1
set hidden                            " Keep buffers around after closing them
set history=50
set hlsearch
set ignorecase
set incsearch                         " search as you type
set laststatus=2                      " Always show the status line
set linebreak
set list                              " show trailing whitespace and tabs
set listchars=tab:\▸\ ,trail:•,extends:>,precedes:<
set modelines=1
set mouse=a
set noequalalways
set nowrap                            " Stop wrapping goddamnit
set number
set pastetoggle=<F7>
set ruler
set scrolljump=3
set scrolloff=5
set shell=/bin/bash
set shiftwidth=4                      " size of an 'indent'
set shortmess=atI
set showcmd                           " Display incomplete commands
set showcmd                           " display commands as they are typed
set smartcase
set smarttab                          " make 'tab' insert indents instead of tabs at the beginning of a line
set softtabstop=2                     " a combination of spaces and tabs are used to simulate tab stops at a width other than the (hard)tabstop
set splitbelow
set splitright
set statusline=%<%f\ %h%m%r%{fugitive#statusline()}%=%-14.(%l,%c%V%)\ %P " taken from :help fugitive-statusline
set tabstop=2                         " size of a hard tabstop
set tags=./tags;/
set textwidth=78
set timeoutlen=250                    " Time to wait after ESC
set timeoutlen=600
set ttimeoutlen=50
set visualbell
set wildmenu
set wildmode=list:longest,full        " bash-like command line tab completion
set winheight=24
set winwidth=94
set wrapmargin=2
