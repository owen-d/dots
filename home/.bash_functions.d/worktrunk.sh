# Worktrunk utilities

# Create worktree and launch Claude with permissions bypassed
# Usage: wsc <branch> [-- <claude-args>...]
wsc() {
    local branch="$1"
    shift

    # Skip user's -- if present, we'll add our own
    if [[ "$1" == "--" ]]; then
        shift
    fi

    wt switch --create --execute=claude "$branch" -- \
        --allow-dangerously-skip-permissions \
        --permission-mode=bypassPermissions \
        --chrome \
        "$@"
}
