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

# I use this to avoid having a distinction between login and non-login shells.  This sources the two
# files that might not normally be sourced by zsh on its own.
#
# This is nice because on macOS the PATH is different in a shell than its subshell because of the way
# /etc/zprofile calls path_helper and this keeps my path the same no matter which way it went.
#
if [[ ! -o login ]] ; then
    [[ -r /etc/zprofile ]] && source /etc/zprofile
    source ${ZDOTDIR:-$HOME}/.zprofile
fi
