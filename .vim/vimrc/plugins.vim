" ----------------------------
" Plugins, managed by Vundle!
" ----------------------------

set nocompatible              " Be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" Let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" ----------------
" --- Movement ---
" ----------------
Plugin 'Lokaltog/vim-easymotion'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'rking/ag.vim'
Plugin 'matchit.zip'
Plugin 'kshenoy/vim-signature'
Plugin 'bkad/CamelCaseMotion'

" -----------------------
" --- UI enhancements ---
" -----------------------
Plugin 'scrooloose/nerdtree'
Plugin 'Xuyuanp/nerdtree-git-plugin'
Plugin 'ryanoasis/vim-devicons'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'nathanaelkane/vim-indent-guides'
Plugin 'bufexplorer.zip'
Plugin 'airblade/vim-gitgutter'

" ----------------------------
" --- Autocomplete & Logic ---
" ----------------------------
Plugin 'Valloric/YouCompleteMe'
Plugin 'ternjs/tern_for_vim'
" Snippets
Plugin 'garbas/vim-snipmate'
Plugin 'MarcWeber/vim-addon-mw-utils'
Plugin 'tomtom/tlib_vim'
Plugin 'scrooloose/snipmate-snippets'

" -------------------
" --- Linting (ALE) ---
" -------------------
Plugin 'dense-analysis/ale'

" ----------------------------
" --- Editing enhancements ---
" ----------------------------
Plugin 'scrooloose/nerdcommenter'
Plugin 'tpope/vim-surround'
Plugin 'godlygeek/tabular'
Plugin 'Raimondi/delimitMate'
Plugin 'tpope/vim-unimpaired'
Plugin 'tpope/vim-endwise'
Plugin 'mattn/emmet-vim'
Plugin 'prettier/vim-prettier'

" ---------------------------
" --- Syntax Highlighting ---
" ---------------------------
" HTML & CSS
Plugin 'othree/html5.vim'
Plugin 'cakebaker/scss-syntax.vim'
Plugin 'hail2u/vim-css3-syntax'
Plugin 'csscomb/vim-csscomb'
Plugin 'Valloric/MatchTagAlways'
Plugin 'kien/rainbow_parentheses.vim'

" JavaScript
Plugin 'pangloss/vim-javascript'
Plugin 'neoclide/vim-jsx-improve'
Plugin 'othree/javascript-libraries-syntax.vim'

" Other Languages
Plugin 'tpope/vim-rails'
Plugin 'vim-ruby/vim-ruby'
Plugin 'elzr/vim-json'
Plugin 'moll/vim-node'

" Git
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-rhubarb'

" Utilities
Plugin 'vim-scripts/Tail-Bundle'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
