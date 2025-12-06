source "$(brew --prefix)/opt/kube-ps1/share/kube-ps1.sh"


case "$SHELL" in
    *zsh)
        export PS1='%?|%1d $(kube_ps1)$ '
        ;;
    *)
        export PS1='$(kube_ps1)$ '
        ;;
    esac

setopt extended_glob
setopt share_history
setopt hist_ignore_dups


fpath+=~/.zfunc
autoload -Uz compinit && compinit

# ---- Completion setup ----
# First, replace all instances of fpath and compinit with a clean setup
# Completion setup
fpath=(~/.zsh_completions ~/.zfunc $fpath)
autoload -Uz compinit && compinit

# Enable completion rehashing
zstyle ':completion:*' rehash true
# bun completions
[ -s "/Users/owen/.bun/_bun" ] && source "/Users/owen/.bun/_bun"


# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)
