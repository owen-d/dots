autoload -Uz compinit
compinit

. ~/.bash_aliases

export HISTSIZE=20000
export HISTFILESIZE=20000

export EDITOR=vim

export GIT_SSH_COMMAND="ssh -i ~/.ssh/github_ed25519"

export GOBIN="${HOME}/.local/go/bin"

# Set PATH, MANPATH, etc., for Homebrew.
eval "$(/opt/homebrew/bin/brew shellenv)"

pathappend "${HOME}/.local/bin" "${HOME}/.cargo/bin" "${GOBIN}"

export GPG_TTY=$(tty)

case "$-" in
    # only runs for interactive shells
    *i*)
        source "$(brew --prefix)/opt/kube-ps1/share/kube-ps1.sh"
        export PS1='\W $(kube_ps1) $ '
        source <(kubectl completion zsh 2>/dev/null)
        ;;
esac
