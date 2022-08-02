" Plugin-specific configurations go here

" CtrlP
let g:ctrlp_map = '<c-p>'
map <C-b> :CtrlPBuffer<CR>

" vim-latex
let g:tex_flavor='latex'
let g:Tex_DefaultTargetFormat = 'pdf'
let g:Tex_MultipleCompileFormats = 'dvi,pdf'

" NERD_Commenter
" Add a space before comments
let g:NERDSpaceDelims = 1

" NERD_Tree
let g:NERDTreeWinPos = 'right'
map <Leader>n :NERDTreeFind<cr>
map <Leader>h :NERDTreeToggle %<cr>
let NERDTreeChDirMode=0
let NERDTreeQuitOnOpen=0
let NERDTreeShowHidden=1
let NERDTreeKeepTreeInNewTab=1
let NERDTreeIgnore = ['^\.DS_Store$']
let NERDTreeAutoDeleteBuffer = 1
"Open NERDTree if no files specified
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

" NERDTress File highlighting
function! NERDTreeHighlightFile(extension, fg, bg, guifg, guibg)
 exec 'autocmd filetype nerdtree highlight ' . a:extension .' ctermbg='. a:bg .' ctermfg='. a:fg .' guibg='. a:guibg .' guifg='. a:guifg
 exec 'autocmd filetype nerdtree syn match ' . a:extension .' #^\s\+.*'. a:extension .'$#'
endfunction

call NERDTreeHighlightFile('js', 'green', 'none', 'green', '#151515')
call NERDTreeHighlightFile('js\*', 'green', 'none', 'green', '#151515')
call NERDTreeHighlightFile('jsx', 'green', 'none', 'green', '#151515')
call NERDTreeHighlightFile('jsx\*', 'green', 'none', 'green', '#151515')
call NERDTreeHighlightFile('es6', 'green', 'none', 'green', '#151515')
call NERDTreeHighlightFile('es6\*', 'green', 'none', 'green', '#151515')

call NERDTreeHighlightFile('Provider.js', 'lightGreen', 'none', '#31B53E', '#151515')
call NERDTreeHighlightFile('Provider.js\*', 'lightGreen', 'none', '#31B53E', '#151515')

call NERDTreeHighlightFile('html', 'red', 'none', '#ffa500', '#151515')
call NERDTreeHighlightFile('html\*', 'red', 'none', '#ffa500', '#151515')

call NERDTreeHighlightFile('json', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('json\*', 'yellow', 'none', 'yellow', '#151515')

call NERDTreeHighlightFile('css', 'cyan', 'none', 'cyan', '#151515')
call NERDTreeHighlightFile('css\*', 'cyan', 'none', 'cyan', '#151515')
call NERDTreeHighlightFile('scss', 'cyan', 'none', 'cyan', '#151515')
call NERDTreeHighlightFile('scss\*', 'cyan', 'none', 'cyan', '#151515')

call NERDTreeHighlightFile('php', 'Magenta', 'none', '#ff00ff', '#151515')
call NERDTreeHighlightFile('php\*', 'Magenta', 'none', '#ff00ff', '#151515')
call NERDTreeHighlightFile('rb', 'Magenta', 'none', '#ff00ff', '#151515')
call NERDTreeHighlightFile('rb\*', 'Magenta', 'none', '#ff00ff', '#151515')

call NERDTreeHighlightFile('component.js', '48', 'none', 'green', '#151515')
call NERDTreeHighlightFile('component.js\*', '48', 'none', 'green', '#151515')
call NERDTreeHighlightFile('directive.js', '48', 'none', 'green', '#151515')
call NERDTreeHighlightFile('directive.js\*', '48', 'none', 'green', '#151515')
call NERDTreeHighlightFile('module.js', 'blue', 'none', '#3366FF', '#151515')
call NERDTreeHighlightFile('module.js\*', 'blue', 'none', '#3366FF', '#151515')
call NERDTreeHighlightFile('service.js', 'Magenta', 'none', '#ff00ff', '#151515')
call NERDTreeHighlightFile('service.js\*', 'Magenta', 'none', '#ff00ff', '#151515')
call NERDTreeHighlightFile('controller.js', '77', 'none', 'green', '#151515')
call NERDTreeHighlightFile('controller.js\*', '77', 'none', 'green', '#151515')

call NERDTreeHighlightFile('spec.js', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('spec.js\*', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('cyp.js', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('cyp.js\*', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('a11y.js', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('a11y.js\*', 'yellow', 'none', 'yellow', '#151515')

call NERDTreeHighlightFile('story.js', 'Magenta', 'none', '#ff00ff', '#151515')
call NERDTreeHighlightFile('story.js\*', 'Magenta', 'none', '#ff00ff', '#151515')

call NERDTreeHighlightFile('package.json', 'White', 'none', '#686868', '#151515')
call NERDTreeHighlightFile('package.json\*', 'White', 'none', '#686868', '#151515')
call NERDTreeHighlightFile('package-lock.json', 'White', 'none', '#686868', '#151515')
call NERDTreeHighlightFile('package-lock.json\*', 'White', 'none', '#686868', '#151515')

call NERDTreeHighlightFile('rc', 'Gray', 'none', '#686868', '#151515')
call NERDTreeHighlightFile('rc\*', 'Gray', 'none', '#686868', '#151515')
call NERDTreeHighlightFile('rc.yml', 'Gray', 'none', '#686868', '#151515')
call NERDTreeHighlightFile('rc.yml\*', 'Gray', 'none', '#686868', '#151515')
call NERDTreeHighlightFile('ignore', 'Gray', 'none', '#686868', '#151515')
call NERDTreeHighlightFile('ignore\*', 'Gray', 'none', '#686868', '#151515')
call NERDTreeHighlightFile('config.js', 'Gray', 'none', '#686868', '#151515')
call NERDTreeHighlightFile('config.js\*', 'Gray', 'none', '#686868', '#151515')
call NERDTreeHighlightFile('config.json', 'Gray', 'none', '#686868', '#151515')
call NERDTreeHighlightFile('config.json\*', 'Gray', 'none', '#686868', '#151515')
call NERDTreeHighlightFile('setup.js', 'Gray', 'none', '#686868', '#151515')
call NERDTreeHighlightFile('setup.js\*', 'Gray', 'none', '#686868', '#151515')

" Python-mode
let g:pymode_lint_write = 0

" Rainbow Parentheses
" Always on
au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces

" Syntastic
let g:syntastic_javascript_checkers = ['flow']
let g:syntastic_python_checkers = ['flake8']
let g:syntastic_html_tidy_ignore_errors=[
    \" proprietary attribute \"ng-",
    \" proprietary attribute \"acl-"
\]
let g:syntastic_sass_checkers=["sass_lint"]
let g:syntastic_scss_checkers=["scss_lint"]
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_loc_list_height = 5
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_wq = 1
let g:syntastic_mode="passive"
nmap <F6> :SyntasticToggleMode<CR>

highlight link SyntasticErrorSign SignColumn
highlight link SyntasticWarningSign SignColumn

highlight link SyntasticStyleErrorSign SignColumn
highlight link SyntasticStyleWarningSign SignColumn

" legancy is deprecated so need this line
let g:snipMate = { 'snippet_version' : 1 }

" Tabularize
nmap <Leader>a= :Tabularize /=\zs<CR>
vmap <Leader>a= :Tabularize /=\zs<CR>
nmap <Leader>a: :Tabularize /:\zs<CR>
vmap <Leader>a: :Tabularize /:\zs<CR>
nmap <Leader>a, :Tabularize /,\zs<CR>
vmap <Leader>a, :Tabularize /,\zs<CR>

" ZenCoding
let g:user_emmet_leader_key = '<c-t>'
let g:user_emmet_settings = {'html' : {'indentation' : '    '} }

" Easymotion
map <Leader> <Plug>(easymotion-prefix)

" The Silver Searcher
if executable('ag')
    " search without specs
    command! -nargs=+ Agi :Ag <q-args> --ignore *spec*

    " Use ag over grep
    set grepprg=ag\ --nogroup\ --nocolor\ --path-to-ignore\ ~/dotfiles/.agignore

    " open it if already open in current tab
    let g:ctrlp_switch_buffer = 'e'
    " don't get fancy when choosing working directory
    let g:ctrlp_working_path_mode = 0
    " ag is fast enough that CtrlP doesn't need to cache
    let g:ctrlp_use_caching = 0

    " Use ag in CtrlP for listing files. Lightning fast
    let g:ctrlp_user_command = ['ag %s -l -Q --nocolor --hidden -g ""']
    " If there is a gitignore respect it
    let g:ctrlp_user_command += ['.git', 'cd %s && git ls-files -co --exclude-standard']
endif

" Ignore some folders and files for CtrlP indexing
" Don't think this actually works maybe ds_store
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\.git$\|\.yardoc\|public$|log\|tmp$|build$|bin$',
  \ 'file': '\.so$\|\.dat$|\.DS_Store$'
  \ }
let g:ctrlp_max_files=0

" Airline fonts
" air-line
let g:airline_powerline_fonts = 1

if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

" unicode symbols
let g:airline_left_sep = '»'
let g:airline_left_sep = '▶'
let g:airline_right_sep = '«'
let g:airline_right_sep = '◀'
let g:airline_symbols.linenr = '␊'
let g:airline_symbols.linenr = '␤'
let g:airline_symbols.linenr = '¶'
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.paste = 'Þ'
let g:airline_symbols.paste = '∥'
let g:airline_symbols.whitespace = 'Ξ'

" airline symbols
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ''

" vim-javascript concealing characters hiding syntax with these symbols
let g:javascript_conceal_function             = "ƒ"
let g:javascript_conceal_null                 = "ø"
let g:javascript_conceal_this                 = "@"
let g:javascript_conceal_return               = "⇚"
let g:javascript_conceal_undefined            = "¿"
let g:javascript_conceal_NaN                  = "ℕ"
let g:javascript_conceal_prototype            = "¶"
let g:javascript_conceal_static               = "•"
let g:javascript_conceal_super                = "Ω"
let g:javascript_conceal_arrow_function       = "⇒"
"let g:javascript_conceal_noarg_arrow_function = "🞅"
"let g:javascript_conceal_underscore_arrow_function = "🞅o"

" toggle vim-javascript conceal
map <leader>l :exec &conceallevel ? "set conceallevel=0" : "set conceallevel=1"<CR>

" json
let g:vim_json_syntax_conceal = 0

" Devicons adding symbols for nerdtree etc
let g:WebDevIconsNerdTreeAfterGlyphPadding = ' '

" JSX for js files too
let g:jsx_ext_required = 0

" Fugitive
command! Gd Gdiff

" Indent colouring
let g:indent_guides_auto_colors = 0
let g:indent_guides_enable_on_vim_startup = 1
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=red   ctermbg=233
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=green ctermbg=235

""""""""""""""""""""""""""""""
" => bufExplorer plugin
""""""""""""""""""""""""""""""
let g:bufExplorerDefaultHelp=0
let g:bufExplorerShowRelativePath=1
let g:bufExplorerFindActive=1
let g:bufExplorerSortBy='name'
map <leader>, :BufExplorer<CR>


""""""""""""""""""""""""""""""
" => MRU plugin
""""""""""""""""""""""""""""""
let MRU_Max_Entries = 400
map <leader>m :MRU<CR>
