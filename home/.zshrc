source "$(brew --prefix)/opt/kube-ps1/share/kube-ps1.sh"

# Command execution time tracking
_cmd_start_time=
_cmd_elapsed=

preexec() {
    _cmd_start_time=$EPOCHREALTIME
}

precmd() {
    if [[ -n $_cmd_start_time ]]; then
        local elapsed=$(( EPOCHREALTIME - _cmd_start_time ))
        _cmd_elapsed=$(_human_time $elapsed 6)
        _cmd_start_time=
    else
        _cmd_elapsed="n/a"
    fi
}

# Convert seconds to human-readable, trimmed to max $2 chars
_human_time() {
    local secs=${1%.*}
    local frac=${1#*.}
    local ms=$((10#${frac:0:3}))
    local result

    if (( secs >= 3600 )); then
        result="$((secs/3600))h$((secs%3600/60))m"
    elif (( secs >= 60 )); then
        result="$((secs/60))m$((secs%60))s"
    elif (( secs > 0 )); then
        result="${secs}.${frac:0:1}s"
    else
        result="${ms}ms"
    fi

    echo "${result:0:$2}"
}

case "$SHELL" in
    *zsh)
        export PS1='%?|%1d|$_cmd_elapsed $(kube_ps1)$ '
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
