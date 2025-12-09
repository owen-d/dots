# osx like copy/paste utils for linux!
if [[ $(uname -s) == Linux ]]
  then
    alias pbcopy='xclip -selection clipboard'
    alias pbpaste='xclip -selection clipboard -o'
fi

alias kc='kubectl'

# scatterbrain alias
alias sb='scatterbrain'

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


# Function to manage Git worktrees interactively (external directory structure, corrected exit path)
worktree() {
  # Determine the main repository root path (works from main repo or any worktree)
  local main_repo_root_path
  main_repo_root_path=$(git rev-parse --path-format=absolute --git-common-dir 2>/dev/null)
  if [[ -z "$main_repo_root_path" ]]; then
    echo "System Alert: Operation must be performed within a Git repository or its worktree." >&2
    return 1
  fi
  # --git-common-dir returns the .git directory, so get its parent
  main_repo_root_path=$(dirname "$main_repo_root_path")

  # Derive repository name and parent directory from the main repo root
  local repo_name
  repo_name=$(basename "$main_repo_root_path")
  local parent_dir
  parent_dir=$(dirname "$main_repo_root_path")
  local worktree_base_dir="${parent_dir}/${repo_name}.worktrees"

  # Simplified main branch detection (relative to the main repo context)
  local main_branch
  local git_dir="${main_repo_root_path}/.git"
  if git --git-dir="$git_dir" --work-tree="$main_repo_root_path" show-ref --verify --quiet refs/heads/main; then
      main_branch="main"
  else
      main_branch="master" # Assumes master if main doesn't exist
  fi
  local target_name="$1"

  if [[ -n "$target_name" ]]; then
    # Handle Provided Worktree Name
    local target_path="${worktree_base_dir}/${target_name}"
    # Check if the absolute path exists in the worktree list
    if git worktree list --porcelain | grep "^worktree " | cut -d ' ' -f 2- | grep -q "^${target_path}$"; then
      echo "Navigating to existing worktree: $target_path"
      cd "$target_path" || return 1
    else
      # Create new worktree with a new branch based on selected source
      echo "Worktree '$target_name' not found at expected location. Creating..."
      local branch_choice
      # List branches from the main repository context
      branch_choice=$(git --git-dir="$git_dir" --work-tree="$main_repo_root_path" branch --format='%(refname:short)' | fzf --height 15% --reverse --prompt="Select source branch for '$target_name': ")
      if [[ -n "$branch_choice" ]]; then
        # Ensure the base directory exists
        mkdir -p "$worktree_base_dir" || { echo "System Alert: Failed to create base directory $worktree_base_dir" >&2; return 1; }
        # Create worktree with a new branch (-b) based on the selected source branch
        echo "Executing: git worktree add -b \"$target_name\" \"$target_path\" \"$branch_choice\""
        # Run git worktree add from the main repo context for consistency
        if git --git-dir="$git_dir" --work-tree="$main_repo_root_path" worktree add -b "$target_name" "$target_path" "$branch_choice"; then
           echo "Worktree created. Navigating to $target_path"
           cd "$target_path" || return 1
        else
           echo "System Alert: 'git worktree add' command failed." >&2
           # Simple cleanup attempt
           if [[ -d "$target_path" ]] && ! ls -A "$target_path" | grep -qv '.git'; then
               rmdir "$target_path" 2>/dev/null
           fi
           return 1
        fi
      else
        echo "Worktree creation cancelled."
        return 1
      fi
    fi
  else
    # Handle No Worktree Name Provided
    # List worktree *names* located in the designated external directory
    local worktree_names
    # Use porcelain format for more reliable parsing
    worktree_names=$(git worktree list --porcelain | grep "^worktree " | cut -d ' ' -f 2- | awk -v base="$worktree_base_dir/" '$0 ~ "^" base { sub(base, "", $0); print $0 }')


    local selection
    local exit_option="Exit (Switch to '$main_branch' in main directory)"
    local options="$exit_option\n$worktree_names"

    selection=$(echo -e "$options" | fzf --height 25% --reverse --prompt="Select worktree or Exit: ")

    if [[ "$selection" == "$exit_option" ]]; then
      # Use the correctly identified main repository root path
      echo "Navigating to main repository directory '$main_repo_root_path' and checking out '$main_branch'."
      cd "$main_repo_root_path" && git switch -f "$main_branch"
    elif [[ -n "$selection" ]]; then
      # Selection is a worktree name, reconstruct the path
      local selected_path="${worktree_base_dir}/${selection}"
      if [[ -d "$selected_path" ]]; then
         echo "Navigating to selected worktree: $selected_path"
         cd "$selected_path" || return 1
      else
         echo "System Alert: Selected worktree path '$selected_path' not found." >&2
         return 1
      fi
    else
       echo "No selection made."
    fi
  fi
  return 0
}
