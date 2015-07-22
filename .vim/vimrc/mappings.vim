" Various mappings go here

" Make it easy to edit .vimrc anytime!
map <Leader>; :tabe $MYVIMRC<CR>

" Autoclosing braces
inoremap {<CR> {<CR>}<ESC>O

" Clear all trailing spaces
map <Leader>c :%s/\s\+$//<CR>:nohl<CR>

" Mapping shortcut to remove highlight
map <Leader><Space> :nohl<CR>

map gb :bnext<cr>
map gB :bprev<cr>

" Easier way to save files
map ZX :w<CR>

" Tab to go forward in history, Shift-Tab to go backward.
nmap <Tab> <C-I>
nmap <S-Tab> <C-O>

" Easier browsing of long lines
noremap <Up> gk
noremap <Down> gj
noremap j gj
noremap k gk
noremap 0 g0
noremap ^ g^
noremap $ g$
nnoremap C cg$
nnoremap D dg$
nnoremap I g^i
nnoremap A g$a

" For those pesky :W errors...
command! W w
command! Wq wq
command! WQ wq
command! Q q

" Better scrolling
noremap <C-Y> 5<C-Y>
noremap <C-E> 5<C-E>

" map control backspace to delete the previous word, useful in Windows
imap <C-BS> <C-W>

" Fix that annoying <C-j> imaps mapping problem
" Something /must/ map to <Plug>IMAP_JumpForward in order to remap <C-j>
map <C-SPACE> <Plug>IMAP_JumpForward

" Make it easier to move between windows
nmap <C-H> <C-W>h
nmap <C-J> <C-W>j
nmap <C-K> <C-W>k
nmap <C-L> <C-W>l
imap <C-H> <Esc><C-W>h
imap <C-J> <Esc><C-W>j
imap <C-K> <Esc><C-W>k
imap <C-L> <Esc><C-W>l

" Easier mappings for resizing windows
nnoremap <C-w>< 5<C-w><
nnoremap <C-w>> 5<C-w>>
nmap + 5<C-w>+
nmap _ 5<C-w>-

" Make it easier to paste in insert mode
inoremap PPP <Esc>pa

" While shifting indent, stay in visual mode
vnoremap < <gv
vnoremap > >gv
vnoremap <Space> I<Space><Esc>gv

" Undo and redo in insert mode
inoremap <C-u> <C-o>u
inoremap <C-y> <C-o><C-R>

" Emacs style mappings
inoremap <C-A> <Home>
inoremap <C-E> <End>
inoremap <C-D> <Del>

" Make tab switching easier on macs
if has("mac")
	nmap <D-1> 1gt
	nmap <D-2> 2gt
	nmap <D-3> 3gt
	nmap <D-4> 4gt
	nmap <D-5> 5gt
	nmap <D-6> 6gt
	nmap <D-7> 7gt
	nmap <D-8> 8gt
	nmap <D-9> 9gt
	imap <D-1> <ESC>1gt
	imap <D-2> <ESC>2gt
	imap <D-3> <ESC>3gt
	imap <D-4> <ESC>4gt
	imap <D-5> <ESC>5gt
	imap <D-6> <ESC>6gt
	imap <D-7> <ESC>7gt
	imap <D-8> <ESC>8gt
	imap <D-9> <ESC>9gt
endif
