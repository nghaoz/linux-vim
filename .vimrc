" Setting gvim auto fullscreen when open
    if has('gui_running')
        " Set GVim window to maximize
        " autocmd GUIEnter * call system("wmctrl -ir " . v:windowid . " -b add,maximized_vert,maximized_horz")
        
        " Set GVim window to position (0,0), size 1600x1000 pixels
        autocmd GUIEnter * call system("wmctrl -ir " . v:windowid . " -e 0,0,0,1600,1000")
    endif

" Setting key-bind F11 to toggle fullscreen
    if has('gui_running')
        map <silent> <F11> :call system("wmctrl -ir " . v:windowid . " -b toggle,maximized_vert,maximized_horz")<CR>
    endif

" Setting search
    set hlsearch

" Setting file format
    set encoding=utf-8
    set guifont=Monospace\ Regular\ 11
    set ic

" Setting auto read (auto load)
    set autoread
    set autoread | au CursorHold * checktime | call feedkeys("lh")

" Setting line number
    set nu

" Setting mouse
    set mouse=a

" Setting tab title
    set showtabline=2

" Setting tab
    " set tabstop=4
    " set shiftwidth=4
    " set expandtab
    set autoindent

" Setting theme
    syntax enable
    syntax on
    set background=dark
    " let g:github_colors_block_diffmark = 0
    " colorscheme github
    " let g:airline_theme = "github"
    colorscheme ghdark

" Setting cursor
    " set cursorcolumn
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

" Setting wrap
    set nowrap

" Setting key-bind for comment line
    " Filetype-specific comment leader
    autocmd FileType c,cpp,java,scala             let b:comment_leader = '\/\/'
    autocmd FileType sh,csh,ruby,python,tcsh      let b:comment_leader = '#'
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

    function! CommentLine()
        let line = getline('.')
        if line =~ '\S'
            call setline('.', substitute(line, '^\(\s*\)\(.*\)', '\1' . b:comment_leader . ' \2', ''))
        endif
    endfunction

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

    " Visual mappings
    vnoremap cc :<C-u>call CommentRange(line("'<"), line("'>"))<CR>
    vnoremap bb :<C-u>call UncommentRange(line("'<"), line("'>"))<CR>
    " Normal mappings (single line)
    nnoremap cc :call CommentLine()<CR>
    nnoremap bb :call UncommentLine()<CR>

" Setting auto save
    augroup autosave
        autocmd!
        autocmd BufRead * if &filetype == "" | setlocal ft=text | endif
        autocmd FileType * autocmd TextChanged,InsertLeave <buffer> if &readonly == 0 | silent write | endif
    augroup END

" Setting key-bind
    noremap <C-n> :tabnew<cr>           " open new tab
    noremap <C-w> :q<cr>                " quit file
    noremap <C-\> :vs<cr><C-w>w         " vertical split
    noremap <C-o> :E<cr>                " open file

" Setting status line
    set laststatus=2

    " Status line configuration
    set statusline=%F                                                   " Full file path
    set statusline+=%#LineNr#
    set statusline+=%=
    set statusline+=%#CursorColumn#
    set statusline+=%y                                                  " File type
    set statusline+=\[%l/%L]                                            " Current/Total lines

    " Add tab size display on the right
    set statusline+=\[%{&shiftwidth}\%{&expandtab?'spaces':'tabs'}]

    " Highlighting
    " highlight StatusLine ctermfg=51 guifg=#00ffff
    " highlight StatusLineNC ctermfg=8 ctermbg=17 guifg=#888888 guibg=#001933

    highlight StatusLine guifg=#00ffff guibg=#001933
    highlight StatusLineNC guifg=#888888 guibg=#001933
    
    function! StatusLineColorMonitor()
      let m = mode()
      if m ==# 'i'
        highlight StatusLine guifg=#00ffff guibg=#661900
      elseif m ==# 'R'
        highlight StatusLine guifg=#00ffff guibg=#006619
      else
        highlight StatusLine guifg=#00ffff guibg=#001933
      endif
    endfunction
    
    let g:statusline_timer = 0
    
    function! StatuslineStartTimer()
      if g:statusline_timer == 0
        let g:statusline_timer = timer_start(100, {-> StatusLineColorMonitor()}, {'repeat': -1})
      endif
    endfunction
    
    function! StatuslineStopTimer()
      if g:statusline_timer != 0
        call timer_stop(g:statusline_timer)
        let g:statusline_timer = 0
      endif
    endfunction
    
    augroup DynamicStatusLine
      autocmd!
      autocmd VimEnter,FocusGained * call StatuslineStartTimer()
      autocmd FocusLost,QuitPre * call StatuslineStopTimer()
    augroup END

" Setting NERDTree
    " show hidden files
    let NERDTreeShowHidden=1

    " Exit Vim if NERDTree is the only window remaining in the only tab.
    autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | call feedkeys(":quit\<CR>:\<BS>") | endif

    noremap <C-b> :NERDTreeToggle<cr>

" Setting current selection tab color
    :hi TabLineSel ctermfg=159 ctermbg=0

" Setting fold 
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

" Setting selection word using Shift
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

" Setting select current word using Ctrl D
    nnoremap <C-d> :let @/='\<'.expand('<cword>').'\>'<CR>viw
    inoremap <C-d> <Esc>viw

" Setting for finding selection words
    nnoremap n nzz
    nnoremap N Nzz

" Setting folded lines color
    highlight Folded ctermfg=White ctermbg=DarkBlue guifg=#ffffff guibg=#003366

" Setting split divider color
    highlight VertSplit ctermfg=White ctermbg=DarkBlue guifg=#ffffff guibg=#003366

" Setting reopen at last position
    if has("autocmd")
      au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
    endif

" Setting turn off auto comment after the current commented line
    autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" Setting key-bind reload file
    nnoremap <F5> :edit!<CR>

" Setting key-bind Arrow keys normal mode
    xnoremap <Left>  <Left>
    xnoremap <Right> <Right>
    xnoremap <Up>    <Up>
    xnoremap <Down>  <Down>

" Setting key-bind select line
    nnoremap <C-l> V
    inoremap <C-l> <Esc>V

" Setting key-bind for paste using Ctrl v
    nnoremap <C-v> "+p
    inoremap <C-v> <C-r>+

" Setting key-bind Shift v for Visual mode
    nnoremap V <C-v>

" Setting key-bind for copy using Ctrl c
    " Copy selection to clipboard in visual mode
    vnoremap <C-c> "+y
    
    " Copy current line to clipboard in normal mode
    nnoremap <C-c> "+yy

" Map Shift+Delete to delete the current line in normal mode
    nnoremap <S-Del> dd

" Setting insert/remove 1 tab (4 spaces)
    " Insert mode: VSCode-style Tab only at line start
    inoremap <expr> <Tab> InsertModeTab()
    inoremap <expr> <S-Tab> InsertModeShiftTab()
    
    function! InsertModeTab()
        let sw = &shiftwidth
        let line = getline('.')
        let col = col('.') - 1
        let lead = matchstr(line, '^\s*')
        let leadlen = strlen(lead)
    
        if col <= leadlen
            " Cursor in leading whitespace or empty line → jump to next indent
            let next = ((leadlen / sw) + 1) * sw
            let to_insert = next - leadlen
            " If empty line, insert shiftwidth spaces
            if line == ''
                let to_insert = sw
            endif
            " Insert spaces and move cursor to end of inserted indent
            return repeat(' ', to_insert)
        else
            " Cursor after leading whitespace → normal tab
            return "\<Tab>"
        endif
    endfunction
    
    function! InsertModeShiftTab()
        let sw = &shiftwidth
        let line = getline('.')
        let col = col('.') - 1
        let lead = matchstr(line, '^\s*')
        let leadlen = strlen(lead)
    
        if col <= leadlen && leadlen > 0
            " Cursor in leading whitespace → jump to previous indent
            let last = ((leadlen - 1) / sw) * sw
            if last < 0 | let last = 0 | endif
            " Remove spaces to previous indent
            let remove = leadlen - last
            return "\<C-o>0" . repeat("\<Del>", remove)
        else
            " Cursor after leading whitespace → normal shift-tab
            return "\<C-d>"
        endif
    endfunction

    " Normal mode tab (VSCode-style)
    nnoremap <Tab> :call NormalModeTab()<CR>
    nnoremap <S-Tab> :call NormalModeShiftTab()<CR>
    
    function! NormalModeTab()
        let sw = &shiftwidth
        let line = getline('.')
        let col = col('.') - 1
        let lead = matchstr(line, '^\s*')
        let leadlen = strlen(lead)
    
        if col <= leadlen
            " Cursor in leading whitespace → jump to next multiple of shiftwidth
            let next = ((col / sw) + 1) * sw
            let newline = repeat(' ', next) . substitute(line, '^\s*', '', '')
            call setline('.', newline)
            call cursor(line('.'), next + 1)
        else
            " Not in leading whitespace → insert shiftwidth spaces
            execute "normal! i" . repeat(" ", sw) . "\<Esc>"
        endif
    endfunction
    
    function! NormalModeShiftTab()
        let sw = &shiftwidth
        let line = getline('.')
        let col = col('.') - 1
        let lead = matchstr(line, '^\s*')
        let leadlen = strlen(lead)
    
        if col <= leadlen && leadlen > 0
            " Cursor in leading whitespace → jump to previous multiple of shiftwidth
            let last = (col / sw) * sw
            let newline = repeat(' ', last) . substitute(line, '^\s*', '', '')
            call setline('.', newline)
            call cursor(line('.'), last + 1)
        else
            " Not in leading whitespace → remove up to shiftwidth spaces before cursor
            let before = matchstr(line[:col-1], '\s*$')
            let n = min([sw, strlen(before)])
            if n > 0
                execute "normal! " . n . "dh"
            endif
        endif
    endfunction
    
    " Visual mode tab (VSCode-style)
    vnoremap <Tab> :<C-u>call VisualModeTab()<CR>gv
    vnoremap <S-Tab> :<C-u>call VisualModeShiftTab()<CR>gv
    
    function! VisualModeTab()
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
    
    function! VisualModeShiftTab()
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

" Setting slider 
    set guioptions+=r
    set guioptions+=b

" Map Ctrl+X in visual mode to cut to clipboard
    " Cut selection to clipboard in visual mode
    vnoremap <C-x> "+d
    
    " Cut current line to clipboard in normal mode
    nnoremap <C-x> "+dd

" (Optional) Map Ctrl+X in normal mode to delete the current line and copy to clipboard
    nnoremap <C-x> "+dd

" Setting key-bind for Insert mode
    " nnoremap i a
    nnoremap a <Nop>

" Setting to paste in gvim command line
    cnoremap <C-v> <C-r>+

" Setting when press Home to jump the head of line
    inoremap <Home> <C-o>^
    nnoremap <Home> ^

" Toggle line wrap with Alt+z in gVim
    nnoremap <M-z> :set wrap!<CR>

" Replace selection in visual mode with clipboard content
    vnoremap <C-V> "+p

" Paste clipboard content in normal mode at cursor position
    nnoremap <C-V> "+gP

" Select all
    nnoremap <C-a> ggVG

" Setting unbind x
    nnoremap x <Nop>

" Setting vim bookmark
    let g:bookmark_highlight_lines = 1
    highlight BookmarkLine ctermbg=17 guibg=#001933
    highlight BookmarkSign ctermbg=17 guibg=#001933 guifg=#00ffff
    let g:bookmark_sign = '=='
    let g:bookmark_center = 1

" Setting line number color
    highlight CursorLineNr guifg=#00ffff

" Setting key-bind clear highlight
    nnoremap <S-l> :nohlsearch<CR>

" Setting highlight all word match current word
    " For normal mode: highlight word under cursor with Ctrl f
    nnoremap <C-f> :let @/ = '\<'.expand('<cword>').'\>'<CR>:set hlsearch<CR>
    " For visual mode: highlight selected text with Ctrl f
    vnoremap <C-f> "zy:let @/ = escape(@z, '/\')<CR>:set hlsearch<CR>

" Setting line color
    highlight CursorLine ctermbg=236 guibg=#333333
    highlight CursorColumn ctermbg=236 guibg=#333333

" Setting found word highlight color
    highlight Search ctermfg=blue ctermbg=grey guifg=#0000ff guibg=#888888

" Setting key-bind to jump word using Ctrl Arrow and selecting word using Ctrl Shift Arrow
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

" Setting cursor for gvim
    if has('gui_running')
        set guicursor=n-v-c:ver25-blinkon0,i:ver25-blinkon500-blinkoff500,r:hor20-blinkon500-blinkoff500
    endif

" Setting for Ctrl z to undo in all mode
    " Map Ctrl+Z to Undo in Normal mode
    nnoremap <C-z> u
    
    " Map Ctrl+Z to Undo in Insert mode (returns to insert mode after undo)
    inoremap <C-z> <C-o>u
    
    " Map Ctrl+Z to Undo in Visual mode
    vnoremap <C-z> u

" Setting for NerdTree
    " Setting open file in new tab, open in background
    " Map click and Enter in NERDTree
    autocmd VimEnter * call NERDTreeAddKeyMap({
          \ 'key': '<2-LeftMouse>',
          \ 'scope': 'FileNode',
          \ 'callback': 'OpenSmart',
          \ 'override': 1 })
    autocmd VimEnter * call NERDTreeAddKeyMap({
          \ 'key': '<CR>',
          \ 'scope': 'FileNode',
          \ 'callback': 'OpenSmart',
          \ 'override': 1 })
    
    function! OpenSmart(node)
      let l:path = a:node.path.str()
    
      " Count buffers in the current tab that are *not* the NERDTree buffer
      let l:bufs = tabpagebuflist()
      let l:other = 0
      for b in l:bufs
        if buflisted(b)
          " skip NERDTree buffer
          if exists('t:NERDTreeBufName') && bufname(b) ==# t:NERDTreeBufName
            continue
          endif
          let l:other += 1
        endif
      endfor
    
      if l:other == 0
        " No other buffer → open in current tab
        execute 'edit ' . fnameescape(l:path)
      else
        " Otherwise, open in background tab, then return
        execute 'silent tabedit ' . fnameescape(l:path)
        execute 'tabprevious'
      endif
    endfunction

    " Nerdtree open on right side
    let g:NERDTreeWinPos = "right"

    " window size
    let g:NERDTreeWinSize = 72

" Setting wrap
    set linebreak               " wrap at word boundaries instead of characters
    set breakat=\ \             " what characters Vim can break on (default: space, tabs, etc.)
    set breakindent             " break new line with indent
    set fileencoding=utf-8
    set termencoding=utf-8
    set showbreak=↪ 
    highlight SpecialKey ctermbg=17 guibg=#001933 guifg=#00ffff
