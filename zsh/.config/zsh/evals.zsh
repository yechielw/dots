eval "$(zoxide init zsh)"
eval "$(fzf --zsh)"
eval "$(pyenv init -)"
#eval "$(pyenv virtualenv-init -)"
eval "$(atuin init --disable-up-arrow zsh 2> /dev/null)" 
source  <(atuin gen-completions --shell zsh 2> /dev/null) 
