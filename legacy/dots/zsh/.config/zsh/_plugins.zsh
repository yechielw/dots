[ ! -f $HOME/.config/antigen.zsh ] && curl -sL git.io/antigen -o $HOME/.config/antigen.zsh

source $HOME/.config/antigen.zsh
# antigen use oh-my-zsh
antigen bundle zsh-users/zsh-history-substring-search
antigen bundle zdharma-continuum/fast-syntax-highlighting
#antigen bundle jeffreytse/zsh-vi-mode
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-completions
antigen bundle command-not-found
antigen bundle olivierverdier/zsh-git-prompt
antigen apply
