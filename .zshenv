[[ -f ~/.zsh/debug ]] && echo "--- .zshenv setopt=$(setopt | tr '\n' ' ')" >&2

# If you want the macOS path_helper to set a MANPATH, the variable must
# exist when /etc/zprofile is loaded (ref: man path_helper)
typeset -xUT MANPATH manpath
typeset -xUT INFOPATH infopath
typeset -xUT PATH path

if [[ -r ~/.zshenv.mw ]] ; then
    source ~/.zshenv.mw
fi
