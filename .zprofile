[[ -f ~/.zsh/debug ]] && echo "--- .zprofile setopt=$(setopt | tr '\n' ' ')" >&2

export PAGER="less"
export LESS="-RM~gIJFXQ -x4"
export LESSHISTFILE="${HOME}/.history/less.${HOST%%.*}"
export SYSTEMD_LESS="$LESS"
