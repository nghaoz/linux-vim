<h1>Recommend using Windows Terminal with Remote SSH</h1>

<h2>Windows Terminal setting</h2>

  - Windows Terminal Startup
    - Set Command Prompt as default profile
    - Windows Terminal as default terminal profgram
    - Center on launch
  
  ![window_terminal_startup](https://github.com/user-attachments/assets/74b9ae68-d3f5-4b7a-8d91-1a13237e2f10)

  - Windows Terminal Interaction
    - Automatic copy
    - Plain text format

  ![image](https://github.com/user-attachments/assets/100acb36-98db-4490-92c2-97faec603883)

  - Windows Terminal Actions
    - Unbind `Ctrl C`
    - Unbind `Ctrl V`
    - Unbind `Ctrl Tab`

  - Windows Terminal Command Prompt profile
    - Appearance
      - Cursor shape Filled box
  
  ![image](https://github.com/user-attachments/assets/e95586a6-acba-40de-9af1-2469fc2e9053)


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
