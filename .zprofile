[[ -f ~/.zsh/debug ]] && echo "--- .zprofile setopt=$(setopt | tr '\n' ' ')" >&2

export PAGER="less"
export LESS="-RM~gIJFXQ -x4"
export LESSHISTFILE="${HOME}/.history/less.${HOST%%.*}"
export SYSTEMD_LESS="$LESS"

export PATH="${HOME}/bin:$PATH"

# Turn on color for BSD versions of tools like ls
export CLICOLOR=true

export PATH=${HOME}/bin:${PATH}
