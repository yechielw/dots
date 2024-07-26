eval "$(zoxide init zsh)"
eval "$(fzf --zsh)"
eval "$(atuin init --disable-up-arrow zsh 2> /dev/null)" 
source  <(atuin gen-completions --shell zsh 2> /dev/null) 
