<h2>VIM setting</h2>

  - Create `.vimrc` in `~/`
  
      `touch ~/.vimrc`
  
  - Create `systemverilog.vim` in `~/.vim/syntax/`

      `mkdir -d ~/.vim/syntax/`

      `touch systemverilog.vim`

  - Create `ghdark.vim` or any theme file in `~/.vim/colors/`

    `mkdir -d ~/.vim/colors`

    `touch ghdark.vim`

<h2>Something inside "vimrc"</h2>

  - This config has _auto save_
      - File with auto save (spamming ESC to back to Normal Mode) when after finishing Insert Mode

  - This config has _auto read_
      - File auto reload new data when
          - Has changed in background on local disk (not sure)
          - Gain window focus (return by `fg` after `Ctrl Z`)
          - Some timing moving or not moving with mouse (not sure)

  - This config tab with 4 spaces (pro vcl)

  - Block cursor for Normal Mode and Vertical line for Insert Mode

  - Line comment by `cc` and uncomment by `bb` (author manhd)

  - Show some status of current file
      - Full directory
      - Current line
      - Total line
      - Type of file
      - Size of file
  
  - Shortcut
      - `Ctrl n` Open new empty tab
      - `Ctrl w` Close current tab
      - `Ctrl \` Vertical split current tab on the right
      - `Ctrl o` Open new file
      - `Ctrl Right` Next tab
      - `Ctrl Left` Previous tab
      - `]` Insert 1 tab
      - `[` Remove 1 tab

<h2>Other Plugin</h2>

https://github.com/preservim/nerdtree

https://github.com/vim-scripts/AutoComplPop

https://github.com/adelarsq/vim-matchit
