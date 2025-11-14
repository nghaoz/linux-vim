" set search
set hlsearch

set encoding=utf-8
set guifont=Monospace\ Regular\ 11
set ic

" set auto read when a file is changed from outside
set autoread
set autoread | au CursorHold * checktime | call feedkeys("lh")

" set line number
set nu

" set mouse
set mouse=a

" tab title
set showtabline=2

" tab
function! DetectTab()
    " Prefer 4, then 3, then 2 spaces for shiftwidth/tabstop
    if search('^\s\{4\}\S', 'nw')
        setlocal shiftwidth=4 tabstop=4 expandtab
    elseif search('^\s\{3\}\S', 'nw')
        setlocal shiftwidth=3 tabstop=3 expandtab
    elseif search('^\s\{2\}\S', 'nw')
        setlocal shiftwidth=2 tabstop=2 expandtab
    endif
endfunction
autocmd BufReadPost * call DetectTab()

" set tabstop=4
" set shiftwidth=4
" set expandtab
set autoindent

" theme
syntax enable
syntax on
set background=dark
" let g:github_colors_block_diffmark = 0
" colorscheme github
" let g:airline_theme = "github"
colorscheme ghdark

" cursor
set cursorcolumn
set cursorline
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"
" Reference chart of values:
"   Ps = 0  -> blinking block.
"   Ps = 1  -> blinking block (default).
"   Ps = 2  -> steady block.
"   Ps = 3  -> blinking underline.
"   Ps = 4  -> steady underline.
"   Ps = 5  -> blinking bar (xterm).
"   Ps = 6  -> steady bar (xterm).

" wrap
set nowrap

" quick comment
autocmd FileType c,cpp,java,scala             let b:comment_leader = '\/\/'
autocmd FileType sh,csh,ruby,python           let b:comment_leader = '#'
autocmd FileType conf,fstab                   let b:comment_leader = '#'
autocmd FileType tex                          let b:comment_leader = '%'
autocmd FileType mail                         let b:comment_leader = '>'
autocmd FileType vim                          let b:comment_leader = '"'
autocmd FileType nasm                         let b:comment_leader = ';'
autocmd BufReadPre,FileReadPre *.v,*.sv,*.svh let b:comment_leader = '\/\/'
autocmd BufReadPre,FileReadPre *.csh,*.txt    let b:comment_leader = '#'

function! CommentRange(start, end)
    for lnum in range(a:start, a:end)
        let line = getline(lnum)
        if line =~ '\S'
            call setline(lnum, substitute(line, '^\(\s*\)\(.*\)', '\1' . b:comment_leader . ' \2', ''))
        endif
    endfor
endfunction

vnoremap cc :<C-u>call CommentRange(line("'<"), line("'>"))<CR>

function! UncommentLine()
    if getline('.') =~? '^\s*' . b:comment_leader
        execute 'silent! s/^\(\s*\)' . b:comment_leader . ' \s\?/\1/'
    endif
endfunction

function! UncommentRange(start, end)
    for lnum in range(a:start, a:end)
        let line = getline(lnum)
        if line =~? '^\s*' . b:comment_leader
            call setline(lnum, substitute(line, '^\(\s*\)' . b:comment_leader . ' \?', '\1', ''))
        endif
    endfor
endfunction

vnoremap bb :<C-u>call UncommentRange(line("'<"), line("'>"))<CR>

nnoremap cc :call CommentLine()<CR>
nnoremap bb :call UncommentLine()<CR>

" auto save file
augroup autosave
    autocmd!
    autocmd BufRead * if &filetype == "" | setlocal ft=text | endif
    autocmd FileType * autocmd TextChanged,InsertLeave <buffer> if &readonly == 0 | silent write | endif
augroup END

" shortcuts
noremap <C-n> :tabnew<cr>
noremap <C-w> :q<cr>
noremap <C-\> :vs<cr><C-w>w
noremap <C-o> :E<cr>

" status line
set laststatus=2

" Status line configuration
set statusline=%F                                                   " Full file path
set statusline+=%#LineNr#
set statusline+=%=
set statusline+=%#CursorColumn#
set statusline+=%y                                                  " File type
set statusline+=\[%l/%L\ lines]                                     " Current/Total lines

" Add tab size display on the right
set statusline+=\[Tab:%{&shiftwidth}\ %{&expandtab?'spaces':'tabs'}]

" Highlighting
highlight StatusLine ctermfg=51 guifg=#00ffff
highlight StatusLineNC ctermfg=8 ctermbg=17 guifg=#888888 guibg=#001933

" NERDtree setting
" show hidden files
let NERDTreeShowHidden=1

" Exit Vim if NERDTree is the only window remaining in the only tab.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | call feedkeys(":quit\<CR>:\<BS>") | endif

noremap <C-b> :NERDTreeToggle<cr>

" Re-Config the Tab color
:hi TabLineSel ctermfg=159 ctermbg=0

" Fold 
augroup filtype_verilog
    " autocmd!
    autocmd FileType Verilog,verilog_systemverilog setlocal foldmethod=indent
    autocmd BufNewFile,BufRead *.v,*.sv,*.svh setlocal foldmethod=indent
    " autocmd BufNewFile,BufRead *.v,*.sv,*.svh let b:match_words='\<function\>:\<endfunction\>,\<task\>:\<endtask\>,\<begin\>:\<end\>,\<`protect\>:\<endprotect\>,\<generate\>:\<endg$
augroup END
runtime macros/matchit.vim
" set foldlevel=99
" use za to fold/unfold current level
" use z-shift-a to fold/unfold all from current level
" use z-shift-r to unfold all

" Select with shift + arrows
inoremap    <S-Left>              <Left><C-o>v
inoremap    <S-Right>             <C-o>v
inoremap    <S-Up>                <Left><C-o>v<Up><Right>
inoremap    <S-Down>              <C-o>v<Down><Left>
inoremap    <S-Home>              <C-o>v<Home>
inoremap    <S-End>               <C-o>v<End>
imap        <C-S-Left>            <S-Left><C-Left>
imap        <C-S-Right>           <S-Right><C-Right>
vnoremap    <S-Left>              <Left>
vnoremap    <S-Right>             <Right>
vnoremap    <S-Up>                <Up>
vnoremap    <S-Down>              <Down>
vnoremap    <S-Home>              <Home>
vnoremap    <S-End>               <End>
nnoremap     <S-Left>             v<Left>
nnoremap     <S-Right>            v<Right>
nnoremap     <S-Up>               v<Up>
nnoremap     <S-Down>             v<Down>
nnoremap     <S-Home>             v<Home>
nnoremap     <S-End>              v<End>

" Auto unselect when not holding shift
vmap        <Left>                <Esc>
vmap        <Right>               <Esc><Right>
vmap        <Up>                  <Esc><Up>
vmap        <Down>                <Esc><Down>

" Select current word with Ctrl D
nnoremap <C-d> :let @/='\<'.expand('<cword>').'\>'<CR>viw
inoremap <C-d> <Esc>viw

" Find current selection
nnoremap n nzz
nnoremap N Nzz

" Foled lines color
highlight Folded ctermfg=White ctermbg=DarkBlue guifg=#ffffff guibg=#003366

" split divider color
highlight VertSplit ctermfg=White ctermbg=DarkBlue guifg=#ffffff guibg=#003366

" reopen at last posistion
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
endif

" turn off auto comment
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" reload button -> should use when reading file only
nnoremap <F5> :edit!<CR>

" bind arrow key in normal mode
xnoremap <Left>  <Left>
xnoremap <Right> <Right>
xnoremap <Up>    <Up>
xnoremap <Down>  <Down>

" select line
nnoremap <C-l> V
inoremap <C-l> <Esc>V

" Paste from clipboard using Ctrl+V
nnoremap <C-v> "+p
inoremap <C-v> <C-r>+

" Map 'V' (Shift+v) to visual block mode (normally <C-v>)
nnoremap V <C-v>

" In visual mode, Ctrl+C copies to system clipboard
vnoremap <C-c> "+y

" Map Shift+Delete to delete the current line in normal mode
nnoremap <S-Del> dd

" auto insert/remove 1 tab (4 spaces)
function! TabToNextIndentColAtCursor()
    let sw = &shiftwidth
    let line = getline('.')
    let col = col('.') - 1
    " If cursor is in leading whitespace, treat as indentation
    let lead = matchstr(line, '^\s*')
    let leadlen = strlen(lead)
    if col <= leadlen
        " Indent the leading whitespace up to next shiftwidth
        let next = ((leadlen / sw) + 1) * sw
        let newline = repeat(' ', next) . substitute(line, '^\s*', '', '')
        call setline('.', newline)
        " Move cursor to the corresponding col
        call cursor(line('.'), next + 1)
    else
        " Insert spaces at current cursor col for next indent boundary
        let pad = sw - ((col - 1) % sw)
        execute 'normal! i' . repeat(' ', pad)
    endif
endfunction
function! TabToPrevIndentColAtCursor()
    let sw = &shiftwidth
    let line = getline('.')
    let col = col('.') - 1
    let lead = matchstr(line, '^\s*')
    let leadlen = strlen(lead)
    if col <= leadlen && leadlen > 0
        " Unindent leading whitespace to the previous shiftwidth boundary
        let last = ((leadlen - 1) / sw) * sw
        if last < 0 | let last = 0 | endif
        let newline = repeat(' ', last) . substitute(line, '^\s*', '', '')
        call setline('.', newline)
        call cursor(line('.'), last + 1)
    else
        " Remove spaces before cursor, up to one indent level
        let before = matchstr(line[:col-1], '\s*$')
        let n = min([sw, strlen(before)])
        if n > 0
            execute "normal! " . n . "dh"
        endif
    endif
endfunction
function! VisualTabToNextIndentCol()
    let sw = &shiftwidth
    let l1 = line("'<")
    let l2 = line("'>")
    for i in range(l1, l2)
        let line = getline(i)
        let lead = matchstr(line, '^\s*')
        let leadlen = strlen(lead)
        let next = ((leadlen / sw) + 1) * sw
        let newline = repeat(' ', next) . substitute(line, '^\s*', '', '')
        call setline(i, newline)
    endfor
endfunction
function! VisualTabToPrevIndentCol()
    let sw = &shiftwidth
    let l1 = line("'<")
    let l2 = line("'>")
    for i in range(l1, l2)
        let line = getline(i)
        let lead = matchstr(line, '^\s*')
        let leadlen = strlen(lead)
        let last = ((leadlen - 1) / sw) * sw
        if last < 0 | let last = 0 | endif
        let newline = repeat(' ', last) . substitute(line, '^\s*', '', '')
        call setline(i, newline)
    endfor
endfunction
" Normal mode
nnoremap <Tab> :call TabToNextIndentColAtCursor()<CR>
nnoremap <S-Tab> :call TabToPrevIndentColAtCursor()<CR>

" Insert mode
inoremap <Tab> <Esc>:call TabToNextIndentColAtCursor()<CR>a
inoremap <S-Tab> <Esc>:call TabToPrevIndentColAtCursor()<CR>a

" Visual mode (indent/unindent selected lines)
vnoremap <Tab> :<C-u>call VisualTabToNextIndentCol()<CR>gv
vnoremap <S-Tab> :<C-u>call VisualTabToPrevIndentCol()<CR>gv

" slider 
set guioptions+=r
set guioptions+=b

" Map Ctrl+X in visual mode to cut to clipboard
vnoremap <C-x> "+d

" (Optional) Map Ctrl+X in normal mode to delete the current line and copy to clipboard
nnoremap <C-x> "+dd

" little thing bind for insert mode
nnoremap i a
nnoremap a <Nop>

" paste in gvim command line
cnoremap <C-v> <C-r>+

" bind for press home
inoremap <Home> <C-o>^
nnoremap <Home> ^

" Toggle line wrap with Alt+z in gVim
nnoremap <M-z> :set wrap!<CR>

" Replace selection in visual mode with clipboard content
vnoremap <C-V> "+p

" Paste clipboard content in normal mode at cursor position
nnoremap <C-V> "+gP

" Paste in insert mode at cursor position
inoremap <C-V> <C-R>+

" Select all
nnoremap <C-a> ggVG

" unbind x
nnoremap x <Nop>

" vim bookmark
let g:bookmark_highlight_lines = 1
highlight BookmarkLine ctermbg=17 guibg=#001933
highlight BookmarkSign ctermbg=17 guibg=#001933 guifg=#00ffff
let g:bookmark_sign = '=='
let g:bookmark_center = 1

" line number color
highlight CursorLineNr guifg=#00ffff

" clear highlight
nnoremap <S-l> :nohlsearch<CR>

" highlight all word match current word
" For normal mode: highlight word under cursor with Ctrl f
nnoremap <C-f> :let @/ = '\<'.expand('<cword>').'\>'<CR>:set hlsearch<CR>
" For visual mode: highlight selected text with Ctrl f
vnoremap <C-f> "zy:let @/ = escape(@z, '/\')<CR>:set hlsearch<CR>

" line color
highlight CursorLine ctermbg=236 guibg=#333333

" find word highlight color
highlight Search ctermfg=blue ctermbg=grey guifg=#0000ff guibg=#888888

" === Normal Mode ===
nnoremap <C-Right> w
nnoremap <C-Left> b

" Start visual mode and select a word forward/backward (Shift+Ctrl+Arrow)
nnoremap <S-C-Right> vew
nnoremap <S-C-Left> vb

" === Visual Mode ===
vnoremap <C-Right> e
vnoremap <C-Left> b

vnoremap <S-C-Right> e
vnoremap <S-C-Left> b

" === Insert Mode ===
inoremap <C-Right> <C-o>w
inoremap <C-Left> <C-o>b
