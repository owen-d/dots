source "$(brew --prefix)/opt/kube-ps1/share/kube-ps1.sh"


case "$SHELL" in
    *zsh)
        export PS1='%?|%1d $(kube_ps1)$ '
        ;;
    *)
        export PS1='$(kube_ps1)$ '
        ;;
    esac

which gimme &> /dev/null && . <(gimme 1.19) &> /dev/null