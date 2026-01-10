" ==================================================
" MISCELLANEOUS SETTINGS
" ==================================================

" --- Backups & Swap Files ---
" Keep the directory clean: save all backups/swaps in one place.
" The 'mkdir' command ensures the folder exists.
silent execute '!mkdir -p ~/.vim_backups'

" Note: The trailing // tells Vim to use the full path in the filename.
" This prevents 'projectA/index.js' swap overwriting 'projectB/index.js'.
set backupdir=~/.vim_backups//
set directory=~/.vim_backups//
set backup                      " Enable backups

" --- Persistence (Viminfo/Shada) ---
if has('nvim')
  " NeoVim uses Shada (Shared Data)
  set shada+=n~/.shada
  " Map Backspace to 'Window Left' (Only in NeoVim as per your snippet)
  nmap <BS> <C-W>h
else
  " Classic Vim uses viminfo
  " '10  : marks remembered for 10 files
  " "100 : save up to 100 lines for registers
  " :20  : command line history
  " %    : save buffer list
  set viminfo='10,\"100,:20,%,n~/.viminfo
endif

" --- Auto-Commands ---

" 1. Return to last edit position when opening files
autocmd BufReadPost *
  \ if line("'\"") > 1 && line("'\"") <= line("$") |
  \   exe "normal! g'\"" |
  \ endif

" 2. Syntax Highlighting Accuracy
" 'fromstart' is extremely slow on large files.
" 'minlines=200' is a safer balance between speed and accuracy.
autocmd BufEnter * syntax sync minlines=200
