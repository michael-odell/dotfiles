[[ -f ~/.zsh/debug ]] && echo "--- .zshenv setopt=$(setopt | tr '\n' ' ')" >&2

fpath=(~/.zsh/functions $fpath)
autoload ${fpath[1]}/*(:t)

if [[ ${OSTYPE} == darwin* ]] ; then
    # If you want the macOS path_helper to set a MANPATH, the variable must
    # exist when /etc/zprofile is loaded (ref: man path_helper)
    #
    # This needs to be in .zshenv and not .zprofile in order for these to be set in non-login shells
    typeset -xT MANPATH manpath
    typeset -xT INFOPATH infopath
fi

print -v HOSTNAME_SHORT -P %m     # Set HOSTNAME_SHORT in OS-independent way
[[ -r ~/.zshenv.local ]] && source ~/.zshenv.local


# NOTE: The (N) in the list "nulls" the item if the directory doesn't
# exist
typeset -xUT PRJPATH prjpath
prjpath=(~/src/*/(N) ~/src(N) ~/wd/*/(N) ~/wd(N) ~/contrib/*/(N) ~/contrib(N) ~/src/learn(N) ~/.zsh/plugins(N) ~/ai)


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

export TZ="America/Denver"
export ANSIBLE_NOCOWS=1
export RIPGREP_CONFIG_PATH=$HOME/.config/ripgrep/config

# Note -- overridden with nvim if available in .zshrc for interactive sessions
export EDITOR=vi

export PAGER="less"
export LESS="-RM~gIJFXQ -x4"
export LESSHISTFILE="${HOME}/.history/less.${HOST%%.*}"
export SYSTEMD_LESS="$LESS"
export KOPIA_CONFIG_PATH=$HOME/.config/kopia/$HOSTNAME_SHORT
