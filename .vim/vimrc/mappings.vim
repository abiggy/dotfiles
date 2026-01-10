" ==================================================
" MAPPINGS & SHORTCUTS
" ==================================================

" --- Leader Keys ---
" Note: By default, <Leader> is backslash (\).
" You can change it to comma or space if you prefer:
" let mapleader = ","

" 1. Fast Config Editing
" Points directly to your .vimrc file (adjust filename if it's not .vimrc)
map <Leader>; :e ~/.vimrc<CR>

" 2. Clear Search Highlighting (Common & Useful)
map <Leader><Space> :nohl<CR>

" 3. Remove Trailing Whitespace
map <Leader>c :%s/\s\+$//<CR>:nohl<CR>

" --- Navigation ---

" Visual Line Motion (Handle wrapped lines naturally)
noremap <Up> gk
noremap <Down> gj
noremap j gj
noremap k gk

" Line Start/End Improvements
noremap 0 g0
noremap ^ g^
noremap $ g$

" Buffer Switching
map gb :bnext<CR>
map gB :bprev<CR>

" Window Movement (Control + H/J/K/L)
" Note: If <C-H> doesn't work, your terminal might treat it as Backspace.
nmap <C-H> <C-W>h
nmap <C-J> <C-W>j
nmap <C-K> <C-W>k
nmap <C-L> <C-W>l

" Window Resizing (Arrow keys or +/-)
nmap <C-w>< 5<C-w><
nmap <C-w>> 5<C-w>>
nmap + 5<C-w>+
nmap _ 5<C-w>-

" --- Editing & Workflow ---

" Stay in Visual Mode when shifting indentation
vnoremap < <gv
vnoremap > >gv

" Search & Replace helpers
" Map Space in Visual Mode to insert at start of line
vnoremap <Space> I<Space><Esc>gv

" Map F1 to Esc (Prevents accidental Help opening)
map <F1> <Esc>
imap <F1> <Esc>

" Common Command Typos (W/Q instead of w/q)
command! W w
command! Wq wq
command! WQ wq
command! Q q

" Sudo Write (Save as root if you forgot sudo)
command! Wsudo w !sudo tee % > /dev/null

" --- Search Tools (Ag/Grep) ---
" Uses the 'ag.vim' plugin you installed
nnoremap <Leader>a :Ag<SPACE>
" Grep the word under cursor
nnoremap <Leader>A :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>

" --- Clipboard (Mac) ---
" Use the system clipboard (*)
set clipboard=unnamed

" Copy/Paste shortcuts (Windows style, helpful on Mac too)
vmap <C-c> "+y
vmap <C-x> "+c

" --- Mac Specifics ---
if has("mac")
  " Command+Number to switch tabs (MacVim specific)
  nmap <D-1> 1gt
  nmap <D-2> 2gt
  nmap <D-3> 3gt
  nmap <D-4> 4gt
  nmap <D-5> 5gt
  imap <D-1> <ESC>1gt
  imap <D-2> <ESC>2gt
  imap <D-3> <ESC>3gt
  imap <D-4> <ESC>4gt
  imap <D-5> <ESC>5gt
endif
