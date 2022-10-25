source "$(brew --prefix)/opt/kube-ps1/share/kube-ps1.sh"
export PS1='$(kube_ps1) $ '

which gimme &> /dev/null && . <(gimme 1.19) &> /dev/null