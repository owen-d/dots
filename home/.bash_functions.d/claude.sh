# Claude utilities

# Run Claude with permissions bypassed and Chrome MCP
# Usage: cc [--continue] [<claude-args>...]
cc() {
    if [[ "$1" == "-h" || "$1" == "--help" ]]; then
        cat <<EOF
Usage: cc [--continue] [<claude-args>...]

Run Claude with permissions bypassed and Chrome MCP enabled.

Options:
  --continue    Continue the previous conversation
  -h, --help    Show this help message
EOF
        return 0
    fi

    local continue_flag=""

    if [[ "$1" == "--continue" ]]; then
        continue_flag="--continue"
        shift
    fi

    claude \
        --allow-dangerously-skip-permissions \
        --permission-mode=bypassPermissions \
        --chrome \
        $continue_flag \
        "$@"
}
