alias ll        "ls -alF --color=auto"

set ip = "hostname -I | awk '{print $1}' | tr -d '[:space:]'"
alias cwdcmd ' \
  if ( "$cwd" == "$HOME" ) then \
    set prompt = "\n[%T]%{\e]2;%~\a%}[%m:%n][%{\033[1;32m%}~%{\033[0m%}]\n%{\033[1;36m%}Haoz %#%{\033[0m%}%s "; \
  else \
    set path_without_last = dirname "$cwd"; \
    set last_dir = basename "$cwd"; \
    if ( "$path_without_last" == "$HOME" ) set path_without_last = "~"; \
    set prompt = "\n[%T]%{\e]2;%~\a%}[%m:%n][%{\033[1;36m%}$path_without_last/%{\033[0m%}%{\033[1;32m%}$last_dir%{\033[0m%}]\n%{\033[1;36m%}Haoz %#%{\033[0m%}%s "; \
  endif'
cwdcmd

alias gf "grep -rn"

alias gvim 'gvim \!* & -geometry 1600x1000'

