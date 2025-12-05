export HISTSIZE=20000
export HISTFILESIZE=20000

export EDITOR=vim

export GIT_SSH_COMMAND="ssh -i ~/.ssh/id_ed25519"

export GOBIN="${HOME}/.local/go/bin"

export PATH="${PATH}:${HOME}/.local/bin:${HOME}/.cargo/bin:${GOBIN}"

export GPG_TTY=$(tty)

export GOBIN="${HOME}/.local/go/bin"
export PATH="${PATH}:${GOBIN}"

. "$HOME/.cargo/env"
