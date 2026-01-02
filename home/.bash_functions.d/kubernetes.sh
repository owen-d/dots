# Kubernetes utility functions

oom-finder() {
    # usage: oom-finder <namespace> <name-label>
    kc -n "${1}" get pod -l name="${2}" -o json | jq '.items[] | select(.status.containerStatuses[].lastState.terminated.reason == "OOMKilled")' | jq '.metadata.name'
}
