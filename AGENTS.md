# Dotfiles Repository Guide

Personal dotfiles for Apple Silicon MacBook Pro.

## Structure

```
dots/
├── home/                    # Symlinked to ~/ via setup.sh
│   ├── .config/
│   │   ├── alacritty/       # Terminal emulator config
│   │   ├── git/             # Git config (user, aliases, defaults)
│   │   └── worktrunk/       # Worktrunk CLI config (LLM commit generation)
│   ├── .zshrc               # Shell prompt, completions, history
│   ├── .zprofile            # PATH, tool init, interactive shell setup
│   ├── .zshenv              # Environment variables (EDITOR, GOBIN, etc.)
│   ├── .bash_aliases        # Aliases and shell functions
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
- **worktrunk**: Git worktree management + LLM commit messages
- **OrbStack**: Container runtime (Docker alternative)

### Git
- SSH key: `~/.ssh/id_ed25519`
- Default branch: `main`
- Pull: fast-forward only
- HTTPS → SSH rewrite for github.com

### Shell Functions (`.bash_aliases`)
- `worktree [name]` - Create/switch git worktrees (fzf-powered)
- `worktree-accept <branch> [target]` - Merge worktree branch and cleanup
- `rept <interval> <cmd>` - Repeat command with interval
- `random_bytes [n]` - Generate random hex bytes
- `mem <pattern>` - Find processes by memory usage
- `gti` - Typo-tolerant git alias

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
- Aliases and functions go in `.bash_aliases`
- Secrets/keys go in `~/.keys.sh` (not tracked, sourced by `.zprofile`)
