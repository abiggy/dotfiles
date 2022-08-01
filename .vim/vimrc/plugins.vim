" Where all the plugins are specified, using Vundle

" Initialize vundle!
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" ----------------------------
" Plugins, managed by Vundle!
" ----------------------------

" Use to manage plugins!
Bundle 'gmarik/vundle'

" ----------------
" --- Movement ---
" ----------------
" Easier vim motions. Try <Leader><Leader>w or <Leader><Leader>fo
Bundle 'Lokaltog/vim-easymotion'
" Like Command-T or fuzzyfinder. Use to fuzzy find files
Bundle 'kien/ctrlp.vim'

" -----------------------
" --- UI enhancements ---
" -----------------------
" File explorer within Vim
Bundle 'scrooloose/nerdtree'

" ------------------------
" --- Vim enhancements ---
" ------------------------
" Shows 'Nth match out of M' for searches
Bundle 'google/vim-searchindex'
" Allow tab completion when searching
Bundle 'SearchComplete'
" Simple plugin to view most recently used files
Bundle 'mru.vim'
Bundle 'bufexplorer.zip'
Bundle 'airblade/vim-gitgutter'
Bundle 'rking/ag.vim'
" Adds visualizations for vim marks ie mm
Bundle 'kshenoy/vim-signature'

" ----------------------------
" --- Editing enhancements ---
" ----------------------------
" Shortcuts to comment code. Use <Leader>cc or <Leader>c<Space>
Bundle 'scrooloose/nerdcommenter'
" Simple shortcuts to deal with surrounding symbols
Bundle 'tpope/vim-surround'
" Text filtering and alignment
Bundle 'godlygeek/tabular'
" Insert-mode autocompletion for quotes, parens, brackets, etc.
Bundle 'Raimondi/delimitMate'
" Syntax checking in Vim!
" Bundle 'scrooloose/syntastic' " stupidly broken so need it to shut up..
Bundle 'tpope/vim-unimpaired'
Bundle 'tpope/vim-endwise'
" % to match more than just single characters
Bundle 'matchit.zip'
Bundle 'mattn/emmet-vim'

Bundle 'Valloric/YouCompleteMe'
" TERN
Bundle 'ternjs/tern_for_vim'

" snipMate
Bundle 'garbas/vim-snipmate'
" snipMate dependences
Bundle 'MarcWeber/vim-addon-mw-utils'
Bundle 'tomtom/tlib_vim'
Bundle 'scrooloose/snipmate-snippets'

" Language support
Bundle 'tpope/vim-rails'
Bundle 'vim-ruby/vim-ruby'
Bundle 'pangloss/vim-javascript'
Bundle 'elzr/vim-json'
Bundle 'othree/html5.vim'


" Vim Text Objects
Bundle 'bkad/CamelCaseMotion'

" Integrations
Bundle 'tpope/vim-fugitive'

" Colors
"Bundle 'altercation/vim-colors-solarized'
"Bundle 'sjl/badwolf'
" Darkmate Color Scheme
"Bundle 'yearofmoo/Vim-Darkmate'
" Hybrid Theme
"Bundle 'w0ng/vim-Hybrid'
" Vimbrant theme'
"Bundle 'thayerwilliams/vimbrant'
"Tomorrow color theme
"Bundle 'chriskempson/vim-tomorrow-theme'

" Utilities, Dependencies
Bundle 'L9'

" ----------------------------
" --- MY NEW ONES          ---
" ----------------------------
Bundle 'vim-scripts/Tail-Bundle'
" Airline is status bar uplift
Bundle 'vim-airline/vim-airline'
"Airline themes
Bundle 'vim-airline/vim-airline-themes'

" ES6
Bundle 'isRuslan/vim-es6'

" Sassalinter
Bundle 'gcorne/vim-sass-lint'

"Nerdtree git tags for files support
Bundle 'Xuyuanp/nerdtree-git-plugin'
" Angular functionality
Bundle 'burnettk/vim-angular'
" Node js
Bundle 'moll/vim-node'
" Javascript parameter completion
Bundle 'othree/jspc.vim'
" Bunch more symbols for nerdtree and stuff
Bundle 'ryanoasis/vim-devicons'

" Formatting for prettier in vim
Bundle 'prettier/vim-prettier'

" Gbrowse back
Bundle 'tpope/vim-rhubarb'


"Syntax Highlighting

" Javascript syntax library highlighting
Bundle 'othree/javascript-libraries-syntax.vim'
" handle HTML5 syntax highlighting
Bundle 'othree/html5-syntax.vim'
" Expansion of vim's javascript syntax file for HTML5
Bundle '1995eaton/vim-better-javascript-completion'
" Additional JS syntax highlighting
Bundle 'jelera/vim-javascript-syntax'



" CSS Plugins
"Bundle 'skammer/vim-css-color' " This is sooo slow slows HTML and CSS
Bundle 'cakebaker/scss-syntax.vim'
Bundle 'csscomb/vim-csscomb'
Bundle 'hail2u/vim-css3-syntax'

" Highlights the matching HTML tag
Bundle 'Valloric/MatchTagAlways'

" Rainbow parentheses!! :)
Bundle 'kien/rainbow_parentheses.vim'

Bundle 'neoclide/vim-jsx-improve'


" Indent indicator
Bundle 'nathanaelkane/vim-indent-guides'

" Typescript
" Plugin 'leafgarland/typescript-vim'
Bundle 'flowtype/vim-flow'
