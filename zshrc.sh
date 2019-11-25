export PATH=$PATH:/usr/local/go/bin
export GOPATH=/home/radu/projects
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:$HOME/.cargo/env

export GPG_TTY=$(tty)

source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

alias ls="exa -al"
alias k="kubectl"
alias c="code-insiders . -r"
