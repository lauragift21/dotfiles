#!/usr/bin/env bash

# =============================================================================
#                           DOTFILES INSTALLER
# =============================================================================
set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles_backup/$(date +%Y%m%d_%H%M%S)"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_step() {
    echo -e "${BLUE}==>${NC} $1"
}

print_success() {
    echo -e "${GREEN}[OK]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# =============================================================================
# Backup existing dotfiles
# =============================================================================
backup_file() {
    local file="$1"
    if [ -f "$file" ] || [ -d "$file" ]; then
        mkdir -p "$BACKUP_DIR"
        mv "$file" "$BACKUP_DIR/"
        print_warning "Backed up existing $(basename "$file") to $BACKUP_DIR"
    fi
}

# =============================================================================
# Create symlink
# =============================================================================
create_symlink() {
    local src="$1"
    local dest="$2"
    
    backup_file "$dest"
    ln -sf "$src" "$dest"
    print_success "Linked $(basename "$src") -> $dest"
}

# =============================================================================
# Main Installation
# =============================================================================
echo ""
echo "========================================"
echo "       Dotfiles Installation"
echo "========================================"
echo ""

# -----------------------------------------------------------------------------
# Install Homebrew
# -----------------------------------------------------------------------------
print_step "Checking for Homebrew..."
if ! command -v brew &> /dev/null; then
    print_step "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH for Apple Silicon
    if [[ $(uname -m) == "arm64" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
    print_success "Homebrew installed"
else
    print_success "Homebrew already installed"
fi

# -----------------------------------------------------------------------------
# Install Homebrew packages
# -----------------------------------------------------------------------------
print_step "Installing Homebrew packages from Brewfile..."
if [ -f "$DOTFILES_DIR/Brewfile" ]; then
    brew bundle install --file="$DOTFILES_DIR/Brewfile" --no-lock
    print_success "Homebrew packages installed"
else
    print_warning "Brewfile not found, skipping..."
fi

# -----------------------------------------------------------------------------
# Create symlinks
# -----------------------------------------------------------------------------
print_step "Creating symlinks..."

# Shell
create_symlink "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"

# Git
create_symlink "$DOTFILES_DIR/.gitconfig" "$HOME/.gitconfig"

# Starship
mkdir -p "$HOME/.config"
create_symlink "$DOTFILES_DIR/config/starship/starship.toml" "$HOME/.config/starship.toml"

# Neovim
create_symlink "$DOTFILES_DIR/config/nvim" "$HOME/.config/nvim"

# -----------------------------------------------------------------------------
# Configure Git (prompt for user info)
# -----------------------------------------------------------------------------
print_step "Configuring Git..."
echo ""

# Check if git user is already configured
current_name=$(git config --global user.name 2>/dev/null || echo "")
current_email=$(git config --global user.email 2>/dev/null || echo "")

if [ -z "$current_name" ] || [ "$current_name" = "Your Name" ]; then
    read -p "Enter your Git name: " git_name
    git config --global user.name "$git_name"
    print_success "Git name set to: $git_name"
else
    print_success "Git name already set: $current_name"
fi

if [ -z "$current_email" ] || [ "$current_email" = "your.email@example.com" ]; then
    read -p "Enter your Git email: " git_email
    git config --global user.email "$git_email"
    print_success "Git email set to: $git_email"
else
    print_success "Git email already set: $current_email"
fi

# -----------------------------------------------------------------------------
# Install FZF key bindings
# -----------------------------------------------------------------------------
print_step "Setting up FZF..."
if command -v fzf &> /dev/null; then
    $(brew --prefix)/opt/fzf/install --key-bindings --completion --no-update-rc --no-bash --no-fish
    print_success "FZF configured"
else
    print_warning "FZF not found, skipping..."
fi

# -----------------------------------------------------------------------------
# macOS defaults (optional)
# -----------------------------------------------------------------------------
echo ""
read -p "Would you like to apply macOS defaults? (y/n) " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
    print_step "Applying macOS defaults..."
    if [ -f "$DOTFILES_DIR/scripts/macos-defaults.sh" ]; then
        chmod +x "$DOTFILES_DIR/scripts/macos-defaults.sh"
        "$DOTFILES_DIR/scripts/macos-defaults.sh"
        print_success "macOS defaults applied"
    fi
fi

# -----------------------------------------------------------------------------
# Done!
# -----------------------------------------------------------------------------
echo ""
echo "========================================"
echo "       Installation Complete!"
echo "========================================"
echo ""
echo "Next steps:"
echo "  1. Restart your terminal or run: source ~/.zshrc"
echo "  2. Open Neovim to install plugins: nvim"
echo "  3. (Optional) Restart your Mac for all macOS settings to take effect"
echo ""
print_success "Dotfiles installed successfully!"
