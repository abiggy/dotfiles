" Any miscellaneous things go here

" Always jump to last cursor position.
autocmd BufReadPost *
      \ if line("'\"") > 0 && line("'\"") <= line("$") |
      \   exe "normal g`\"" |
      \ endif


" Use a common directory for backups and swp files
" Create it if it doesn't exist
silent execute '!mkdir -p ~/.vim_backups'
set backupdir=~/.vim_backups/
set directory=~/.vim_backups/

" Syntax highlighting from start. Slow but better.
autocmd BufEnter * :syntax sync fromstart

" NeoVim fixes
if has('nvim')
    nmap <BS> <C-W>h
    set viminfo+=n~/.shada
else
    set viminfo='10,\"100,:20,%,n~/.viminfo    " Use viminfo
endif

" Return to last edit position when opening files (You want this!)
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
