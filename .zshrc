[[ -f ~/.zsh/debug ]] && echo "--- .zshrc" >&2

# Allow Ctrl-S as hotkey rather than terminal stop
stty -ixon

# Turn on powerlevel10k "instant prompt" per its docs.
#   - https://github.com/romkatv/powerlevel10k#how-do-i-configure-instant-prompt
# WARNING: no console input allowed from any commands after this.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Load all my functions and completions
fpath+=(~/.zsh/functions)
autoload ~/.zsh/functions/*

ZNAP_DIR=${HOME}/.zsh/znap/znap
if [[ ! -f ${ZNAP_DIR}/znap.zsh ]] ; then
    mkdir -p ${ZNAP_DIR}
    git clone https://github.com/marlonrichert/zsh-snap.git ${ZNAP_DIR}
fi
source ${ZNAP_DIR}/znap.zsh

# Znap's default repo source should be github, via ssh
zstyle :znap:clone: default-server "git@github.com:"
# Don't turn on git-maintenance for me because I don't want it to modify my .gitconfig
zstyle ':znap:*:*' git-maintenance off


# On mac, use the 1Password socket rather than the one set up by launchd when you're local
if [[ ${SSH_AUTH_SOCK} =~ ^/private/tmp/com.apple.launchd \
    && -S "${HOME}/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock" ]] ; then

    SSH_AUTH_SOCK="${HOME}/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
fi


znap source zsh-users/zsh-completions
znap source zdharma-continuum/fast-syntax-highlighting
znap source romkatv/powerlevel10k powerlevel10k

#znap source belak/zsh-utils completion

# I find this adds noticable command lag so I commented it out on 2023-01-14.  Will I notice
# anything missing?
#znap source belak/zsh-utils editor

znap source michael-odell/zsh-history
znap source michael-odell/zsh-homebrew

znap source michael-odell/temp-envselect
alias es=envselect
alias ess=envsubselect
alias k8s=envselect

# My Powerlevel10k (prompt) configuration -- much was generated by `p10k
# configure` but I've edited it a lot since then...
source ~/.p10k.zsh

zstyle ':completion:*' use-cache on
setopt interactive_comments no_beep auto_pushd

alias "ls=ls -F"
alias "ll=ls -ltr"
alias "la=ls -ltra"


alias dotfiles="git --git-dir=$HOME/.dotfiles.git --work-tree=$HOME"


export EDITOR=vi
if which nvim &>/dev/null ; then
    alias vi=nvim
    alias vim=nvim
    export EDITOR=nvim
fi

# Explicitly use emacs bindings even though I have EDITOR set to vi
bindkey -e

# NOTE: The (N) in the list "nulls" the item if the directory doesn't
# exist
typeset -xUT PRJPATH prjpath
prjpath=(~/src(N) ~/contrib(N) ~/src/learn(N) ~/mw(N))


GITHUB=git@github.com:michael-odell
GITHUB_HTTPS=https://github.com/michael-odell
MW_GITHUB=git@github.com:maplewell
MW_GITHUB_HTTPS=https://github.com/maplewell

which gdircolors &>/dev/null && znap eval gdircolors gdircolors

#zstyle ':completion:*' completer _complete _approximate
#zstyle ':completion:*' group-name ''
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}


for cmd in kubectl helm ; do
    if which $cmd &>/dev/null ; then
        znap eval $cmd "$cmd completion zsh"
    fi
done
if which stern >&/dev/null ; then
    znap eval stern "stern --completion zsh"
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
