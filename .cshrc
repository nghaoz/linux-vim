alias ll        "ls -alF --color=auto"

set ip = "hostname -I | awk '{print $1}' | tr -d '[:space:]'"
alias cwdcmd ' \
  if ( "$cwd" == "$HOME" ) then \
    set prompt = "%{\e]2;%~\a%}[%m:%n][$ip][%{\033[1;32m%}~%{\033[0m%}]%#%s "; \
  else \
    set path_without_last = dirname "$cwd"; \
    set last_dir = basename "$cwd"; \
    if ( "$path_without_last" == "$HOME" ) set path_without_last = "~"; \
    set prompt = "%{\e]2;%~\a%}[%m:%n][$ip][%{\033[1;36m%}$path_without_last/%{\033[0m%}%{\033[1;32m%}$last_dir%{\033[0m%}]%#%s "; \
  endif'
cwdcmd

alias gvim 'gvim \!* &'
