[[ -f ~/.zsh/debug ]] && echo "--- .zshrc" >&2

if [[ ! -d ~/.zsh/antidote ]] ; then
    git clone https://github.com/mattmc3/antidote.git .zsh/antidote
fi
source .zsh/antidote/antidote.zsh
antidote load

alias "ls=ls -F --color=auto"
alias "ll=ls -ltr"
alias "la=ls -ltra"

## Powerlevel10k configuration -- mostly generated by `p10k configure`
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

ZSH_EVALCACHE_DIR=${HOME}/.zsh/evalcache
mkdir -p "${ZSH_EVALCACHE_DIR}"

if [[ -x /opt/homebrew/bin/brew ]] ; then
    _evalcache /opt/homebrew/bin/brew shellenv
fi

alias dotfiles="GIT_DIR=$HOME/.dotfiles.git GIT_WORK_TREE=$HOME git"

if which nvim &>/dev/null ; then
    alias vi=nvim
    alias vim=nvim
fi

HISTSIZE=11000
SAVEHIST=10000
HISTFILE=~/.history/${HOST%%.*}
if [[ ${USER} != "odellm" && ${USER} != "modell" && ${USER} != "michael" ]] ; then
    HISTFILE+="-${USER}"
fi


# On mac, use the 1Password socket rather than the one set up by launchd when you're local
if [[ ${SSH_AUTH_SOCK} =~ ^/private/tmp/com.apple.launchd \
    && -S "${HOME}/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock" ]] ; then

    SSH_AUTH_SOCK="${HOME}/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
fi
