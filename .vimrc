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
set smartindent

" theme
syntax enable
syntax on
set background=dark
" setting for vscode_dark_default
" colorscheme codedark
" setting for github_dark
colorscheme ghdark

" cursor
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

" file syntax -> shoutout to manhd
autocmd BufNewFile,BufRead *.v,*.sv,*.svh,*.log set ft=systemverilog

" shortcuts
noremap <C-n> :tabnew<cr>
noremap <C-w> :q<cr>
noremap <C-\> :vs<cr>
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
set statusline+=\[%{FileSize(line2byte('$')+len(getline('$')))}\]

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

" NERDtree setting
" show hidden files
let NERDTreeShowHidden=1

" Exit Vim if NERDTree is the only window remaining in the only tab.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | call feedkeys(":quit\<CR>:\<BS>") | endif

" Open the existing NERDTree on each new tab.
autocmd BufWinEnter * if &buftype != 'quickfix' && getcmdwintype() == '' | silent NERDTreeMirror | endif

noremap <C-b> :NERDTreeToggle<cr>






