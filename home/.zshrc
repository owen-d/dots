source "$(brew --prefix)/opt/kube-ps1/share/kube-ps1.sh"
source "/opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"


case "$SHELL" in
    *zsh)
        export PS1='%?|%1d $(kube_ps1)$ '
        ;;
    *)
        export PS1='$(kube_ps1)$ '
        ;;
    esac

which gimme &> /dev/null && . <(gimme 1.21.3) &> /dev/null
# pnpm
export PNPM_HOME="/Users/owendiehl/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"
# pnpm end

setopt extended_glob

fpath+=~/.zfunc
autoload -Uz compinit && compinit

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"