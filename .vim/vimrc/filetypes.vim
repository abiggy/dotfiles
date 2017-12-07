" Configuration for specific filetypes go here

au BufNewFile,BufRead *.coffee set ft=coffee
au BufNewFile,BufRead *.cgi set ft=perl
au BufNewFile,BufRead *.dot set list smartindent
au BufNewFile,BufRead *.rb setlocal ts=2 sts=2 sw=2 expandtab
au BufNewFile,BufRead Gemfile,*.ru set ft=ruby
au BufNewFile,BufRead *.js setlocal ts=2 sts=2 sw=2 expandtab
au BufNewFile,BufRead *.jsx setlocal ts=2 sts=2 sw=2 expandtab
au BufNewFile,BufRead *.es6 set ft=javascript ts=2 sts=2 sw=2 expandtab
au BufNewFile,BufRead *.json setlocal ts=2 sts=2 sw=2 expandtab
au BufNewFile,BufRead *.md set nolist
au BufNewFile,BufRead *.ml set tw=0 wrapmargin=0 " No automatic line wrapping
au BufNewFile,BufRead *.otl set ft=vo_base nolist noexpandtab smartindent tw=100
au BufNewFile,BufRead *.otl colors vo_dark
au BufNewFile,BufRead *.php,*.phpt,*.htm,*.html set ts=2 sts=2 sw=2 expandtab
au BufNewFile,BufRead *.phpt set ft=php
au BufNewFile,BufRead *.py setlocal ts=4 sts=4 sw=4 expandtab
au BufNewFile,BufRead *.s{a,c}ss syntax cluster sassCssAttributes add=@cssColors
au BufNewFile,BufRead *.s{a,c}ss setlocal ts=2 sts=2 sw=2 expandtab
au BufNewFile,BufRead *.slim set ft=slim
au BufNewFile,BufRead *.sls set ft=yaml
au BufNewFile,BufRead *.tex set nolist
au BufNewFile,BufRead *.thor set ft=ruby
au BufNewFile,BufRead *.tt,*.tt2 set ft=tt2html ts=4 sts=4 sw=4 expandtab
au BufReadPost fugitive://* set bufhidden=delete
au BufNewFile,BufRead *.less set filetype=less

au FileType less set omnifunc=csscomplete#CompleteCSS

" Ctrl-N to lint current PHP file
autocmd FileType php noremap <C-N> :w<CR>:!/usr/bin/env php %<CR>
" \m to run current file in PHP
autocmd FileType php noremap <Leader>m :w<CR>:!/usr/bin/env php -l %<CR>
" Ctrl-N to lint current Ruby file
autocmd FileType ruby noremap <C-N> :w<CR>:!/usr/bin/env ruby %<CR>
" \m to run current file in Ruby
autocmd FileType ruby noremap <Leader>m :w<CR>:!/usr/bin/env ruby -c %<CR>

let g:haskell_indent_if = 2

let javaScript_fold=1         " JavaScript

" prettier JS files on save
autocmd FileType javascript setlocal formatprg=prettier\ --stdin\ --print-width\ 120\ --trailing-comma\ es5
autocmd BufNewFile,BufRead *.jsx setlocal formatprg=prettier\ --stdin\ --print-width\ 120\ --trailing-comma\ es5
autocmd BufNewFile,BufRead *.es6 setlocal formatprg=prettier\ --stdin\ --print-width\ 120\ --trailing-comma\ es5
autocmd BufWritePre *.js,*.jsx,*.es6 Neoformat
let g:neoformat_try_formatprg = 1
