[[ -f ~/.zsh/debug ]] && echo "--- .zshrc" >&2
[[ -f ~/.zsh/debug ]] && declare -p path >&2

zstyle ':completion:*' use-cache
mkdir -p ~/.cache/zsh-completion
zstyle ':completion:*' cache-path $HOME/.cache/zsh-completion

print -v HOSTNAME_SHORT -P %m     # Set HOSTNAME_SHORT in OS-independent way

zmodload zsh/datetime

[[ -r ~/.dotfilesrc ]] && source ~/.dotfilesrc
[[ -r ~/.zshrc.local ]] && source ~/.zshrc.local

if [[ ! -d ~/.asdf && ${DOTFILES_INSTALL} -eq 1 ]] ; then
    git clone --branch v0.14.0 \
        -c advice.detachedHead=false \
        https://github.com/asdf-vm/asdf.git ~/.asdf
fi

export ASDF_FORCE_PREPEND=yes
export ASDF_DATA_DIR=$HOME/.local/asdf
[[ -r ~/.asdf/asdf.sh ]] && source ~/.asdf/asdf.sh

# NOTE: as of 2024-04, bug affects helm/stern version locking on arm mac -- see asdf-ensure-available
#asdf-ensure-available \
#    argocd 2.9.3 \
#    helm 3.14.4 \
#    kubectl 1.29.3 \
#    stern 1.28.0 \
#    terraform  1.2.9 \
#    oci 3.44.3 \

# On mac, use the 1Password socket rather than the one set up by launchd when you're local
if [[ ${SSH_AUTH_SOCK} =~ ^/private/tmp/com.apple.launchd \
    && -S "${HOME}/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock" ]] ; then

    SSH_AUTH_SOCK="${HOME}/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
fi

: ${DOTFILES_PLUGIN_SOURCE:=git@github.com:michael-odell}
: ${CACHE_DIR=${XDG_CACHE_HOME:-$HOME/.cache}}

plugin-def ${DOTFILES_PLUGIN_SOURCE}/fast-syntax-highlighting
plugin-def ${DOTFILES_PLUGIN_SOURCE}/powerlevel10k
plugin-def ${DOTFILES_PLUGIN_SOURCE}/zsh-history

if [[ -r ~/.onbmc ]] ; then
    plugin-def ${DOTFILES_PLUGIN_SOURCE}/odell-bmc
    plugin-def https://saascm-gogs.onbmc.com/SaaS-Platform/bmc-tools.git
fi

if [[ -n ${commands[gogs]} && -n ${commands[op]} ]] ; then
    alias gogs="op run -- gogs"
fi

plugin-def ${DOTFILES_PLUGIN_SOURCE}/zsh-completions

#plugin-def ${DOTFILES_PLUGIN_SOURCE}/temp-envselect

PLUGIN_UPDATE_FREQUENCY=30d plugins-update

alias dotfiles="git --git-dir=$HOME/.dotfiles.git --work-tree=$HOME"
if [[ -r ~/.dotfiles.git/FETCH_HEAD ]] && older-than 30d ~/.dotfiles.git/FETCH_HEAD ; then
    echo "Updating local dotfiles..." >&2
    dotfiles pull
fi

# Allow Ctrl-S as hotkey rather than terminal stop
stty -ixon

# Load powerlevel10k instant prompt.  Ref: https://github.com/romkatv/powerlevel10k#how-do-i-configure-instant-prompt
# WARNING: no console input allowed from any commands after this.
if [[ -r "${CACHE_DIR}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${CACHE_DIR}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

fpath=($fpath ~/.asdf/completions)

plugins-load

autoload -Uz compinit
compinit -d ~/.cache/zcompdump


alias es=envselect
alias ess=envsubselect
alias k8s=envselect

# My Powerlevel10k (prompt) configuration -- much was generated by `p10k
# configure` but I've edited it a lot since then...
source ~/.p10k.zsh

setopt interactive_comments no_beep auto_pushd

alias "ls=ls -F"
alias "ll=ls -ltr"
alias "la=ls -ltra"




export EDITOR=vi
if [[ -n ${commands[nvim]} ]] ; then
    alias vi=nvim
    alias vim=nvim
    export EDITOR=nvim
fi

# Explicitly use emacs bindings even though I have EDITOR set to vi
bindkey -e


GITHUB=git@github.com:michael-odell
GITHUB_HTTPS=https://github.com/michael-odell

which gdircolors &>/dev/null && cached-source gdircolors

#zstyle ':completion:*' completer _complete _approximate
#zstyle ':completion:*' group-name ''
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

# Autocomplete lowercase-only into the correct case
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'


for cmd in kubectl helm podman kind nerdctl ; do
    if [[ -n ${commands[$cmd]} ]] ; then
        cached-source $cmd completion zsh
    fi
done
if [[ -n ${commands[stern]} ]]; then
    cached-source stern --completion zsh
fi
if [[ -n ${commands[op]} ]] ; then
    cached-source op completion zsh
    compdef _op op
fi

# Generate terminfo files if they haven't been yet.  I do this to
# support extra character styles that are available in iterm2.  I
# learned about it (of course!) on stackoverflow:
#    https://apple.stackexchange.com/questions/266333/how-to-show-italic-in-vim-in-iterm2
#
if [[ ! -d ~/.terminfo ]] ; then
    tic -o ~/.terminfo ~/.config/terminfo/xterm-256color.terminfo
    tic -o ~/.terminfo ~/.config/terminfo/tmux.terminfo
    tic -o ~/.terminfo ~/.config/terminfo/tmux-256color.terminfo
fi

# Bash-style "help" command for builtins.  There's some weirdness here in that by default zsh sets
# up run-help to be an alias to man (I don't know where this comes from) and here I disable that.
#
# See this stackoverflow for as much information as I presently know about it:
#  - https://stackoverflow.com/questions/4405382/how-can-i-read-documentation-about-built-in-zsh-commands
if [[ -d /usr/share/zsh/${ZSH_VERSION}/help ]] ; then
    unalias run-help
    autoload run-help
    HELPDIR=/usr/share/zsh/${ZSH_VERSION}/help
    alias help=run-help
fi

# Output from compinstall that I haven't decided whether or not to keep
#zstyle ':completion:*' completer _expand _complete _ignored _correct
#zstyle ':completion:*' expand prefix suffix
#zstyle ':completion:*' format '-- %d --'
#zstyle ':completion:*' group-name ''
#zstyle ':completion:*' list-colors ''
#zstyle ':completion:*' max-errors 2
#zstyle ':completion:*' menu select=long
#zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
#zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*' use-compctl true
zstyle ':completion:*' verbose true
#zstyle :compinstall filename '/Users/michael/.zshrc'

# For new tmux windows, cd into the stored, project dir if available
if [[ $- == *i* && -n ${TMUX_PRJDIR} ]] ; then
    cd ${TMUX_PRJDIR}
    # But don't do it in subshells
    unset TMUX_PRJDIR
fi
