function powerline_precmd() {
    PS1="$(/home/radu/projects/bin/powerline-go -cwd-max-depth 1 -cwd-mode dironly -error $? -shell zsh -modules user,host,cwd,perms,git)"
}

function install_powerline_precmd() {
  for s in "${precmd_functions[@]}"; do
    if [ "$s" = "powerline_precmd" ]; then
      return
    fi
  done
  precmd_functions+=(powerline_precmd)
}

if [ "$TERM" != "linux" ]; then
    install_powerline_precmd
fi
