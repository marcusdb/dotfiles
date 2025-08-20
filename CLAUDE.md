# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a macOS dotfiles repository that manages system configuration using GNU Stow for symlink management. The repository contains configurations for various development tools and applications.

## Key Commands

### Installation
```bash
# Main installation script (requires macOS)
./install.sh

# Install Homebrew packages only
./brew.sh

# Deploy specific configurations using stow
stow zsh -t ~/
stow tmux -t ~/
stow oh-my-posh -t ~/
stow claude -t ~/
stow karabiner -t ~/
stow nvim -t ~/.config/nvim
```

### Stow Management
```bash
# Deploy a configuration
stow <package> -t <target_directory>

# Remove a configuration
stow -D <package> -t <target_directory>

# Restow (useful for updates)
stow -R <package> -t <target_directory>
```

## Architecture and Structure

### Directory Organization
Each top-level directory represents a stowable package that can be symlinked to the appropriate location:

- **zsh/**: Zsh shell configuration (.zshrc and related files)
- **tmux/**: Tmux terminal multiplexer configuration
- **nvim/**: Neovim configuration based on NvChad framework
- **oh-my-posh/**: Oh My Posh prompt theme configuration
- **claude/**: Claude Code settings and configurations
- **karabiner/**: Karabiner-Elements keyboard customization

### Installation Flow
1. **install.sh**: Main orchestrator that:
   - Accepts Xcode license
   - Installs Homebrew
   - Installs Oh My Zsh
   - Runs brew.sh for package installation
   - Deploys configurations via stow

2. **brew.sh**: Manages all Homebrew packages including:
   - Development tools (neovim, tmux, gh, nvm)
   - Kubernetes tools (kind, tilt, kubectl, helm)
   - Productivity apps (Raycast, Obsidian, Visual Studio Code)
   - Utilities (fzf, fd, zoxide, bat)

### Key Configuration Details

#### Neovim (nvim/)
- Based on NvChad framework
- Configuration modules in lua/
- Lazy plugin management with lazy-lock.json
- LSP configurations in lua/configs/lspconfig.lua
- Custom mappings in lua/mappings.lua

#### Claude Code Integration
- Settings stored in claude/.claude/settings.json
- Custom agents in claude/.claude/agents/
- Audio hooks for notifications in claude/.claude/hooks/
- MCP server configurations enabled for various services

#### Shell Environment
- Oh My Zsh as the Zsh framework
- Oh My Posh for prompt theming
- Zoxide for smarter directory navigation
- FZF for fuzzy finding
- Zsh autosuggestions and history substring search

## Important Notes

- This repository uses GNU Stow for symlink management - always use stow commands to deploy/remove configurations
- The install.sh script contains a merge conflict marker (line 31) that needs resolution
- Homebrew packages include both CLI tools and GUI applications (casks)
- Node.js is managed via nvm (installs Node 22 by default)
- Language Tool and autokbisw services are automatically started via brew services