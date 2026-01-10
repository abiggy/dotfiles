" ==================================================
" SPELLING & TYPO CORRECTION
" ==================================================

" --- 1. Auto-Correct Common Typos (Insert Mode) ---
" These trigger automatically when you press Space or a punctuation mark.

" English
iab countires countries
iab hte the
iab taht that
iab teh the
iab peroid period

" Coding Specific
iab fitler filter
iab fitlerConfig filterConfig
iab fitlerPanel filterPanel
iab lenght length
iab chagne change
iab chagnes changes
iab consoel console
iab reutrn return
iab funciton function

" --- 2. Vim Spell Checker (Optional) ---
" Vim has a built-in spell checker (highlights red underlines).

" Toggle Spell Check with <Leader>s
map <Leader>s :setlocal spell! spelllang=en_us<CR>

" Tips for Spell Check:
" ]s          -> Jump to next misspelled word
" [s          -> Jump to previous misspelled word
" z=          -> Show suggestion list for word under cursor
" zg          -> Add word to dictionary (Good)
" zw          -> Mark word as wrong (Wrong)
