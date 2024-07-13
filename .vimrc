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

" quick comment
autocmd FileType c,cpp,java,scala             let b:comment_leader = '\/\/haoz'
autocmd FileType sh,csh,ruby,python           let b:comment_leader = '#haoz'
autocmd FileType conf,fstab                   let b:comment_leader = '#haoz'
autocmd FileType tex                          let b:comment_leader = '%haoz'
autocmd FileType mail                         let b:comment_leader = '>haoz'
autocmd FileType vim                          let b:comment_leader = 'haoz'
autocmd FileType nasm                         let b:comment_leader = ';haoz'
autocmd BufReadPre,FileReadPre *.v,*.sv,*.svh let b:comment_leader = '\/\/haoz'
autocmd BufReadPre,FileReadPre *.csh,*.txt    let b:comment_leader = '#haoz'

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

" file syntax and quick comment -> shoutout to manhd
autocmd BufNewFile,BufRead *.v,*.sv,*.svh,*.log set syntax=systemverilog
