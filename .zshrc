[[ -f ~/.zsh/debug ]] && echo "--- .zshrc" >&2

ZGEN_RESET_ON_CHANGE=(${HOME}/.zshrc)
if [[ ! -r ~/.zsh/zgenom ]] ; then
    git clone https://github.com/jandamm/zgenom.git ~/.zsh/zgenom
fi
source ~/.zsh/zgenom/zgenom.zsh

ZGEN_DIR=${HOME}/.zsh/plugins
ZSH_EVALCACHE_DIR=${HOME}/.zsh/evalcache
mkdir -p "${ZGEN_DIR}" "${ZSH_EVALCACHE_DIR}"

zgenom autoupdate
if ! zgenom saved ; then
    zgenom load zdharma-continuum/fast-syntax-highlighting
    zgenom load zsh-users/zsh-completions
    zgenom load romkatv/powerlevel10k powerlevel10k

    zgenom load belak/zsh-utils completion
    zgenom load belak/zsh-utils editor

    zgenom load mroth/evalcache

    zgenom load michael-odell/zsh-history

    zgenom save

    # zgenom doezn't _do_ anything with this evalcache for me, but
    # because of the zgenom autoupdate, I know it'll run periodically so
    # I tie clearing of the cache to the process
    rm ~/.zsh/evalcache/*
fi

setopt interactive_comments no_beep

alias "ls=ls -F --color=auto"
alias "ll=ls -ltr"
alias "la=ls -ltra"

## Powerlevel10k configuration -- mostly generated by `p10k configure`
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Note: all my macs are M1 or later so this is okay (now?), but brew
# uses a different path on intel macs.
if [[ -z "${HOMEBREW_PREFIX}" && -x /opt/homebrew/bin/brew ]] ; then
    _evalcache /opt/homebrew/bin/brew shellenv
fi

alias dotfiles="GIT_DIR=$HOME/.dotfiles.git GIT_WORK_TREE=$HOME git"

if which nvim &>/dev/null ; then
    alias vi=nvim
    alias vim=nvim
fi

# On mac, use the 1Password socket rather than the one set up by launchd when you're local
if [[ ${SSH_AUTH_SOCK} =~ ^/private/tmp/com.apple.launchd \
    && -S "${HOME}/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock" ]] ; then

    SSH_AUTH_SOCK="${HOME}/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
fi


GITHUB=git@github.com:michael-odell
GITHUB_HTTPS=https://github.com/michael-odell
MW_GITHUB=git@github.com:maplewell
MW_GITHUB_HTTPS=https://github.com/maplewell
