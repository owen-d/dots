# osx like copy/paste utils for linux!
if [[ $(uname -s) == Linux ]]
  then
    alias pbcopy='xclip -selection clipboard'
    alias pbpaste='xclip -selection clipboard -o'
fi

alias kc='kubectl'

# fat fingers
gti() {
  git $@
}

random_bytes () {
  head -c "${1:-16}" < /dev/urandom | xxd -p
}

rept () {
  while :;
  do
      local t="$1"
      local output="$(${@:2} 2>&1)"
      clear && echo "${output}" && sleep $t
  done
}

docker-rmi-none () {
  docker images | grep non | awk '{print $3}' | xargs -n 1 docker rmi
}

mem() {
    ps -eo rss,pid,euser,args:100 --sort %mem | grep -v grep | grep -i $@ | awk '{printf $1/1024 "MB"; $1=""; print }'
}

jsonnet-lint() {
    git diff --name-only | grep -E '(jsonnet|libsonnet)' | xargs -n 1 jsonnetfmt -i
}

oom-finder() {
    # usage: oom-finder <namespace> <name-label>
    kc -n "${1}" get pod -l name="${2}" -o json | jq '.items[] | select(.status.containerStatuses[].lastState.terminated.reason == "OOMKilled")' | jq '.metadata.name'
}

tk() {
  $TK_DIR/tk $@
}