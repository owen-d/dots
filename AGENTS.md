# Dotfiles Repository Guide

Personal dotfiles for Apple Silicon MacBook Pro.

## Structure

```
dots/
├── home/                    # Symlinked to ~/ via setup.sh
│   ├── .bash_functions.d/   # Modular shell functions (one file per domain)
│   │   ├── docker.sh        # Docker utilities
│   │   └── kubernetes.sh    # Kubernetes utilities
│   ├── .config/
│   │   ├── alacritty/       # Terminal emulator config
│   │   ├── git/             # Git config (user, aliases, defaults)
│   │   └── worktrunk/       # Worktrunk CLI config (LLM commit generation)
│   ├── .zshrc               # Shell prompt, completions, history
│   ├── .zprofile            # PATH, tool init, interactive shell setup
│   ├── .zshenv              # Environment variables (EDITOR, GOBIN, etc.)
│   ├── .bash_aliases        # Aliases, small functions, and .bash_functions.d loader
│   ├── .tmux.conf           # Tmux with vim-style navigation, C-o prefix
│   └── .amethyst.yml        # Tiling window manager config
├── reference/               # App-managed configs (backup/reference only)
│   └── vscode/              # VS Code settings, keybindings
└── setup.sh                 # Symlink installer
```

## Setup Mechanism

`setup.sh` symlinks everything under `home/` to the corresponding location in `~/`:
- Finds all files under `home/`
- Creates parent directories as needed
- Force-symlinks each file to home directory

VS Code configs in `reference/` are copied (not symlinked) since VS Code manages them.

## Key Configurations

### Shell (zsh)
- **Prompt**: `exit_code|directory|elapsed_time $(kube_ps1)$`
- **Command timing**: Tracks execution time of each command
- **Completions**: kubectl, fzf, bun, worktrunk (`wt`)
- **History**: 20k lines, shared across sessions, deduped

### Key Tools Configured
- **fzf**: Fuzzy finder with zsh integration
- **kube-ps1**: Kubernetes context in prompt
- **worktrunk**: Git worktree management + LLM commit messages (via `claude-commit`)
- **OrbStack**: Container runtime (Docker alternative)

### Scripts (`~/.local/bin/`)
- **claude-commit** - Generates commit messages using Claude CLI (haiku model). Reads prompt from stdin, outputs message. Used by worktrunk for `wt merge` and `wt step commit`.

### Git
- SSH key: `~/.ssh/id_ed25519`
- Default branch: `main`
- Pull: fast-forward only
- HTTPS → SSH rewrite for github.com

### Shell Functions

Functions are organized in two locations:

**`.bash_aliases`** - Small inline functions:
- `rept <interval> <cmd>` - Repeat command with interval
- `random_bytes [n]` - Generate random hex bytes
- `mem <pattern>` - Find processes by memory usage
- `gti` - Typo-tolerant git alias

**`.bash_functions.d/*.sh`** - Modular functions by domain:
- `docker.sh` - Docker utilities (`docker-rmi-none`)
- `kubernetes.sh` - K8s utilities (`oom-finder`)
- `worktrunk.sh` - Worktrunk utilities (`wsc` - create worktree + launch Claude)

The loader in `.bash_aliases` sources all `*.sh` files from `~/.bash_functions.d/`.

### Tmux
- Prefix: `C-o` (not default C-b)
- Pane navigation: `prefix + h/j/k/l` (vim-style)
- Window reorder: `C-h`/`C-l`
- Mouse scrolling enabled

### Amethyst (Window Manager)
- Mod1: `Option`
- Mod2: `Option+Shift`
- Layouts: fullscreen, tall, tall-right, column
- Focus: `mod1 + h/j/k/l`
- Swap: `mod2 + h/j/k/l`

### VS Code (reference only)
- Vim extension with spacemacs-style bindings
- Space as leader key (vspacecode)
- Go/Rust/Python/TypeScript formatting configured
- Custom keybindings with `ctrl+l` prefix for LSP actions

## Adding New Configs

1. Place config file at `home/<path>` mirroring its location under `~/`
2. Run `./setup.sh` to create symlink
3. For app-managed configs, use `reference/` directory instead

## Conventions

- Environment variables go in `.zshenv` (loaded for all shells)
- Interactive shell setup goes in `.zprofile`
- Prompt and completion setup goes in `.zshrc`
- Aliases and small functions go in `.bash_aliases`
- Larger functions go in `.bash_functions.d/<domain>.sh`
- Secrets/keys go in `~/.keys.sh` (not tracked, sourced by `.zprofile`)

## Adding New Functions

1. Create `home/.bash_functions.d/<domain>.sh` (e.g., `aws.sh`, `git.sh`)
2. Add functions to the file with a comment header
3. Run `./setup.sh` - files are symlinked individually
4. New shell sessions will auto-source the file
