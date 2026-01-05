# Worktrunk utilities

# Create worktree and launch Claude with permissions bypassed
# Usage: wsc <branch> [-- <claude-args>...]
wsc() {
    if [[ "$1" == "-h" || "$1" == "--help" ]]; then
        cat <<EOF
Usage: wsc <branch> [-- <claude-args>...]

Create/switch to a worktree and launch Claude with permissions bypassed and Chrome MCP enabled.

Arguments:
  <branch>          Branch name to create/switch to

Options:
  -h, --help        Show this help message

Examples:
  wsc feature-foo
  wsc bugfix-bar -- --model opus
EOF
        return 0
    fi

    local branch="$1"
    shift

    # Skip user's -- if present, we'll add our own
    if [[ "$1" == "--" ]]; then
        shift
    fi

    wt switch --create --execute=clc "$branch" -- "$@"
}

# Create worktree and launch Claude orchestrator with permissions bypassed
# Usage: wsco <branch> [-- <claude-args>...]
wsco() {
    if [[ "$1" == "-h" || "$1" == "--help" ]]; then
        cat <<EOF
Usage: wsco <branch> [-- <claude-args>...]

Create/switch to a worktree and launch Claude orchestrator with permissions bypassed and Chrome MCP enabled.

Arguments:
  <branch>          Branch name to create/switch to

Options:
  -h, --help        Show this help message

Examples:
  wsco feature-foo
  wsco bugfix-bar -- --model opus
EOF
        return 0
    fi

    local branch="$1"
    shift

    # Skip user's -- if present, we'll add our own
    if [[ "$1" == "--" ]]; then
        shift
    fi

    wt switch --create --execute=clco "$branch" -- "$@"
}
