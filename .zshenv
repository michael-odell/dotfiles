[[ -f ~/.zsh/debug ]] && echo "--- .zshenv setopt=$(setopt | tr '\n' ' ')" >&2

if [[ ${OSTYPE} == darwin* ]] ; then
    # If you want the macOS path_helper to set a MANPATH, the variable must
    # exist when /etc/zprofile is loaded (ref: man path_helper)
    #
    # This needs to be in .zshenv and not .zprofile in order for these to be set in non-login shells
    typeset -xT MANPATH manpath
    typeset -xT INFOPATH infopath
fi

path+=(
    # Multipass stores aliases here on macos
    "$HOME/Library/Application Support/multipass/bin"(N)
)
