" --- General Settings ---
set nocompatible             " Disable Vi compatibility
set encoding=utf8
set shell=/bin/bash          " Use bash for shell commands
set history=1000             " Increased from 50 (modern machines can handle it)
set mouse=a                  " Enable mouse in all modes

" --- File Handling ---
set autoread                 " Reload file if changed externally
set autowrite                " Auto-save before switching buffers/making tags
set hidden                   " Allow hiding buffers with unsaved changes
set backspace=indent,eol,start " Backspace works as expected
set modelines=1              " Read modelines from files (security limit)

" --- Indentation (Standardized to 2 spaces) ---
" Note: I changed shiftwidth to 2 to match your tabstop settings
set expandtab                " Use spaces instead of tabs
set tabstop=2                " Size of a hard tabstop
set softtabstop=2            " Simulation of tab width
set shiftwidth=2             " Size of an indent (<< / >>)
set autoindent               " Copy indent from previous line
set smarttab                 " <Tab> uses shiftwidth at start of line

" --- Searching ---
set hlsearch                 " Highlight search results
set incsearch                " Jump to result while typing
set ignorecase               " Ignore case when searching...
set smartcase                " ...unless capital letters are used

" --- UI & Visuals ---
set number                   " Show line numbers
set cursorline               " Highlight the current line
set ruler                    " Show cursor position
set showcmd                  " Show incomplete commands in bottom right
set laststatus=2             " Always show status line
set visualbell               " Flash screen instead of beeping
set diffopt+=vertical        " Vertical diffs are better

" --- Whitespace & Wrapping ---
set list                     " Show invisible characters...
set listchars=tab:\▸\ ,trail:•,extends:>,precedes:<
set nowrap                   " Do not wrap lines
set linebreak                " Break lines at words (if wrapping is enabled)
set textwidth=78             " Wrap text at 78 chars (for comments/git)

" --- Folds ---
set foldmethod=indent        " Fold based on indentation
set foldlevel=20             " Open all folds by default
set nofoldenable             " Disable folding at startup

" --- Splits ---
set splitbelow               " New horizontal splits go below
set splitright               " New vertical splits go right

" --- Timeouts ---
" Fixed duplicate timeoutlen entries
set timeoutlen=600           " Wait 600ms for mapping sequences (e.g. Leader)
set ttimeoutlen=50           " Wait 50ms for key codes (eliminates ESC lag)

" --- Window Management ---
" Note: These force active windows to be large. Remove if splits jump too much.
set winheight=24
set winwidth=94
set noequalalways            " Don't force equal size windows

" --- Status Line ---
" REMOVED: set statusline=...
" Reason: You are using vim-airline plugin, which replaces this.
