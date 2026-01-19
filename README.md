# Dotfiles

My personal dotfiles for macOS.

## What's Included

- **Zsh** - Shell configuration with aliases, functions, and completions
- **Git** - Global git configuration with useful aliases
- **Neovim** - Modern Vim configuration with lazy.nvim plugin manager
- **Starship** - Cross-shell prompt configuration
- **Homebrew** - Brewfile with essential tools and applications
- **macOS** - Sensible macOS defaults

## Quick Install

```bash
git clone https://github.com/lauragift21/dotfiles.git ~/Code/infra/dotfiles
cd ~/Code/infra/dotfiles
chmod +x install.sh
./install.sh
```

## Manual Installation

### 1. Install Homebrew

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### 2. Install packages

```bash
brew bundle install --file=Brewfile
```

### 3. Create symlinks

```bash
ln -sf ~/Code/infra/dotfiles/.zshrc ~/.zshrc
ln -sf ~/Code/infra/dotfiles/.gitconfig ~/.gitconfig
ln -sf ~/Code/infra/dotfiles/config/starship/starship.toml ~/.config/starship.toml
ln -sf ~/Code/infra/dotfiles/config/nvim ~/.config/nvim
```

### 4. Apply macOS defaults (optional)

```bash
./scripts/macos-defaults.sh
```

## Structure

```
dotfiles/
├── .gitconfig          # Git configuration
├── .gitignore          # Git ignore patterns
├── .zshrc              # Zsh configuration
├── Brewfile            # Homebrew packages
├── install.sh          # Installation script
├── README.md           # This file
├── config/
│   ├── nvim/
│   │   └── init.lua    # Neovim configuration
│   └── starship/
│       └── starship.toml # Starship prompt config
└── scripts/
    └── macos-defaults.sh # macOS system preferences
```

## Customization

- Add local overrides in `.zshrc.local` (won't be tracked by git)
- Edit the Brewfile to add/remove packages
- Modify `scripts/macos-defaults.sh` for different system preferences

## Updating

```bash
cd ~/Code/infra/dotfiles
git pull
./install.sh
```
