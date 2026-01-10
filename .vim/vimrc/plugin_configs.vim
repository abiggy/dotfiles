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


" Python-mode
let g:pymode_lint_write = 0

" Rainbow Parentheses
" Optimized to load only once per buffer instead of on every keypress
augroup RainbowParams
  autocmd!
  autocmd VimEnter * RainbowParenthesesToggle
  autocmd FileType * RainbowParenthesesLoadRound
  autocmd FileType * RainbowParenthesesLoadSquare
  autocmd FileType * RainbowParenthesesLoadBraces
augroup END

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


" --- YCM & ALE Harmony ---
" Turn off YCM's own diagnostic checking so it doesn't overlap with ALE
let g:ycm_show_diagnostics_ui = 0

" Let ALE handle the heavy lifting for linting
let g:ale_linters = {
\   'javascript': ['eslint', 'flow'],
\   'css': ['csslint'],
\   'scss': ['sass-lint'],
\}
let g:ale_fixers = {
\   'javascript': ['prettier', 'eslint'],
\   'css': ['prettier'],
\}
" Run lint only on save (optional - helps performance)
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_insert_leave = 0
let g:ale_lint_on_enter = 0
let g:ale_lint_on_save = 1
