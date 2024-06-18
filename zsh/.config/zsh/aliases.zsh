
alias diff='diff --color=auto'
alias ip='ip --color=auto'
type eza  > /dev/null && alias ls=eza && alias ll='eza -la -g --icons'
type nala > /dev/null && alias apt=nala
type nvim > /dev/null && alias vi=nvim && alias vim=nvim 
type bat  > /dev/null && alias cat='bat -p'

alias history="history 0" 
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
alias hosts="sudo.exe wsl nvim /mnt/c/Windows/System32/drivers/etc/hosts"
