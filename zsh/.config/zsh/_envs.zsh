eval "$(dircolors -b)"

export LESS_TERMCAP_mb=$'\E[1;31m'     # begin blink
export LESS_TERMCAP_md=$'\E[1;36m'     # begin bold
export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
export LESS_TERMCAP_so=$'\E[01;33m'    # begin reverse video
export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
export LESS_TERMCAP_ue=$'\E[0m'        # reset underline

# Take advantage of $LS_COLORS for completion as well
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'


TIMEFMT=$'\nreal\t%E\nuser\t%U\nsys\t%S\ncpu\t%P'
VIRTUAL_ENV_DISABLE_PROMPT=1

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#999'
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

export internal='10.0.0.0/8 172.16.0.0/12 192.168.0.0/16'

export LESSOPEN="| /usr/share/source-highlight/src-hilite-lesspipe.sh %s"
export LESS=' -R '
export COMMAND_NOT_FOUND_INSTALL_PROMPT=1
export PATH="$HOME/.pyenv/bin:/opt:$HOME/.local/bin:$HOME/go/bin:$PATH"
