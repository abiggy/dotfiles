" --- Filetype Detection Overrides ---
" Only use 'set ft=' if Vim doesn't detect these automatically
au BufNewFile,BufRead *.coffee set ft=coffee
au BufNewFile,BufRead *.es6    set ft=javascript
au BufNewFile,BufRead *.otl    set ft=vo_base
au BufNewFile,BufRead *.phpt   set ft=php
au BufNewFile,BufRead *.slim   set ft=slim
au BufNewFile,BufRead *.thor   set ft=ruby
au BufNewFile,BufRead *.tt,*.tt2 set ft=tt2html
" Using comma separation is safer than {a,c} brace expansion
au BufNewFile,BufRead *.sass,*.scss set ft=scss

" --- Filetype Specific Settings ---
" Use FileType autocmds so these run AFTER plugins have loaded
au FileType ruby,eruby    setlocal ts=2 sts=2 sw=2 expandtab
au FileType javascript    setlocal ts=2 sts=2 sw=2 expandtab
au FileType javascript.jsx setlocal ts=2 sts=2 sw=2 expandtab
au FileType json          setlocal ts=2 sts=2 sw=2 expandtab
au FileType php,html      setlocal ts=2 sts=2 sw=2 expandtab
au FileType python        setlocal ts=4 sts=4 sw=4 expandtab
au FileType tt2html       setlocal ts=4 sts=4 sw=4 expandtab

" Visual tweaks
au FileType markdown      setlocal nolist
au FileType tex           setlocal nolist
au FileType vo_base       setlocal nolist noexpandtab smartindent tw=100
au FileType vo_base       colors vo_dark

" Git Fugitive cleanup
au BufReadPost fugitive://* set bufhidden=delete

" --- Language Specific Mappings ---

" PHP
" Fixed: Leader-l to Lint, Leader-m to Run
autocmd FileType php noremap <Leader>l :w<CR>:!/usr/bin/env php -l %<CR>
autocmd FileType php noremap <Leader>m :w<CR>:!/usr/bin/env php %<CR>

" Ruby
" Fixed: Leader-l to Lint (Check syntax), Leader-m to Run
autocmd FileType ruby noremap <Leader>l :w<CR>:!/usr/bin/env ruby -c %<CR>
autocmd FileType ruby noremap <Leader>m :w<CR>:!/usr/bin/env ruby %<CR>

" CSS / LESS
au FileType less set omnifunc=csscomplete#CompleteCSS
" Add CSS colors to sass/scss files
au FileType scss,sass syntax cluster sassCssAttributes add=@cssColors

" --- Plugin Configurations ---

let g:haskell_indent_if = 2
let javaScript_fold=1

" Prettier Configuration
" Disable default autoformat, then enable it manually for specific types
let g:prettier#autoformat = 0
autocmd BufWritePre *.js,*.jsx,*.mjs,*.ts,*.tsx,*.css,*.less,*.scss,*.json,*.graphql,*.md,*.vue Prettier
