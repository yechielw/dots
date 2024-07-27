eval "$(zoxide init zsh)"
eval "$(fzf --zsh)"
eval "$(atuin init --disable-up-arrow zsh)"
source  <(atuin gen-completions --shell zsh)
eval "$(pyenv init -)"
#eval "$(pyenv virtualenv-init -)"
