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
set tabstop=4
set shiftwidth=4
set expandtab
set autoindent

" theme
syntax enable
syntax on
set background=dark
" let g:github_colors_block_diffmark = 0
" :help github_colors.txt
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

" quick comment ->  shoutout to manhd
autocmd FileType c,cpp,java,scala             let b:comment_leader = '\/\/'
autocmd FileType sh,csh,ruby,python           let b:comment_leader = '#'
autocmd FileType conf,fstab                   let b:comment_leader = '#'
autocmd FileType tex                          let b:comment_leader = '%'
autocmd FileType mail                         let b:comment_leader = '>'
autocmd FileType vim                          let b:comment_leader = '"'
autocmd FileType nasm                         let b:comment_leader = ';'
autocmd BufReadPre,FileReadPre *.v,*.sv,*.svh let b:comment_leader = '\/\/'
autocmd BufReadPre,FileReadPre *.csh,*.txt    let b:comment_leader = '#'

function! CommentLine()
    execute ':silent! s/^\([ |\t]*\)\(.*\)/\1' . b:comment_leader . ' \2/g'
endfunction

function! UncommentLine()
    execute ':silent! s/^\([ \|\t]*\)' . b:comment_leader . ' /\1/g'
endfunction

noremap cc :call CommentLine()<CR>
noremap bb :call UncommentLine()<CR>

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
noremap <C-RIGHT> :tabnext<cr>
noremap <C-LEFT> :tabprevious<cr>

" status line
set laststatus=2
set statusline+=\%F
set statusline+=%#LineNr#
set statusline+=%=
set statusline+=%#CursorColumn#
set statusline+=\%y
set statusline+=\[%l/%L\ lines]
function! FileSize(bytes)
    let l:bytes = a:bytes | let l:sizes = ['B', 'KB', 'MB', 'GB'] | let l:i = 0
        while l:bytes >= 1024 | let l:bytes = l:bytes / 1024.0 | let l:i += 1 | endwhile
        return l:bytes > 0 ? printf(' %.1f%s ', l:bytes, l:sizes[l:i]) : ''
endfunction

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
set foldlevel=99
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
autocmd FileType * let b:tab_leader = '    '

function! TabLine()
    execute ':silent! s/^\([|\t]*\)\(.*\)/\1' . b:tab_leader . '\2/g'
endfunction

function! UntabLine()
    execute ':silent! s/^\([\|\t]*\)' . b:tab_leader . '/\1/g'
endfunction

noremap ] :call TabLine()<CR>
noremap [ :call UntabLine()<CR>

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
highlight BookmarkSign ctermbg=17 guibg=#001933
let g:bookmark_sign = '=='
let g:bookmark_center = 1

" line number color
highlight CursorLineNr ctermfg=white guifg=#ffffff guibg=#2d343a ctermbg=#2d343a

" clear highlight
nnoremap <S-l> :nohlsearch<CR>

" highlight all word match current word
" For normal mode: highlight word under cursor with Ctrl f
nnoremap <C-f> :let @/ = '\<'.expand('<cword>').'\>'<CR>:set hlsearch<CR>
" For visual mode: highlight selected text with Ctrl f
vnoremap <C-f> "zy:let @/ = escape(@z, '/\')<CR>:set hlsearch<CR>

" line color
highlight CursorLine ctermbg=236 guibg=#333333
