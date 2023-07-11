autoload -Uz compinit
compinit


# Set PATH, MANPATH, etc., for Homebrew.
eval "$(/opt/homebrew/bin/brew shellenv)"

. ~/.bash_aliases
[ -f ~/.keys.sh ] && . ~/.keys.sh

case "$-" in
    # only runs for interactive shells
    *i*)
        source <(kubectl completion zsh 2>/dev/null)
        # needed for history to work in zsh+tmux
        bindkey '^R' history-incremental-search-backward
        # restore emacs keymap after setting editor to vim
        # https://stackoverflow.com/questions/23128353/zsh-shortcut-ctrl-a-not-working
        bindkey -e
        ;;
esac

# Added by OrbStack: command-line tools and integration
source ~/.orbstack/shell/init.zsh 2>/dev/null || :
