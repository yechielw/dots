#setopt share_history         # share command history data


ZSH_THEME_GIT_PROMPT_PREFIX=" "
ZSH_THEME_GIT_PROMPT_SUFFIX=" "
function gs {
    if  git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    untracked_count=$(git status --porcelain 2>/dev/null | grep "^??" | wc -l)
    modified_count=$(git status --porcelain 2>/dev/null | grep "^ M" | wc -l)
    echo "$untracked_count|$modified_count "
fi }


PS1='%F{2}[%F{reset}${SSH_TTY:+%n@%m }%~%F{2}]%F{4}%(#.#.$)%F{reset} '
#PROMPT=$'%F{%(#.blue.green)}${debian_chroot:+($debian_chroot)─}${VIRTUAL_ENV:+($(basename $VIRTUAL_ENV))─}[%B%F{reset}$([ -z $SSH_TTY ] || echo "$USER@$HOST ")%F{reset}%(6~.%-1~/…/%4~.%5~)%b%F{%(#.blue.green)}]%B%(#.%F{red}#.%F{blue}$)%b%F{reset} '
# Right-side prompt with exit codes and background processes
RPROMPT=$'%(?.. %? %F{red}%B⨯%b%F{reset})%(1j. %j %F{yellow}%B⚙%b%F{reset}.)'
