[[ -f ~/.zsh/debug ]] && echo "--- .zprofile" >&2

# NO WORKY
#path=( "${HOME}/bin" "${path[@]}" "${HOME}/go/bin"(N) )

# Turn on color for BSD versions of tools like ls
export CLICOLOR=true

load_brew () {
    local brew_path

    if [[ -x /opt/homebrew/bin/brew ]] ; then
        brew_path=/opt/homebrew

    elif [[ -x /usr/local/bin/brew ]] ; then
        brew_path=/usr/local

    else
        return
    fi

    # This (minus the cached-source) is the way brew officially seems to expect you to set up its
    # variables, although I don't like that it puts itself in front of standard system paths.
    #
    # ref: https://docs.brew.sh/Manpage#shellenv
    cached-source ${brew_path}/bin/brew shellenv

    # Add shell completion for brew and brew-installed tools
    #
    # ref: https://docs.brew.sh/Shell-Completion
    fpath+=(${brew_path}/share/zsh/site-functions)

    if [[ -d ${brew_path}/share/google-cloud-sdk ]] ; then
        source ${brew_path}/share/google-cloud-sdk/path.zsh.inc
        source ${brew_path}/share/google-cloud-sdk/completion.zsh.inc
    fi
}
# WARNING: On mac, this ends up re-setting all existing PATH, MANPATH, INFOPATH settings.  Hence why mine
# all follow here
[[ ${OSTYPE} == darwin* ]] && load_brew


path+=(
    "${HOME}/go/bin"(N)

    # Multipass stores aliases here on macos
    "$HOME/Library/Application Support/multipass/bin"(N)
)


if [[ -d ~/.venv && -z ${VIRTUAL_ENV:-} ]] ; then
    export VIRTUAL_ENV=~/.venv
    path=(~/.venv/bin $path)
fi

[[ -f ~/.zsh/debug ]] && echo "--- END .zprofile $(declare -p path)" >&2
