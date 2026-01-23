# =============================================================================
#                              DOTFILES - ZSHRC
# =============================================================================

# -----------------------------------------------------------------------------
# Homebrew
# -----------------------------------------------------------------------------
eval "$(/opt/homebrew/bin/brew shellenv)"

# -----------------------------------------------------------------------------
# Environment Variables
# -----------------------------------------------------------------------------
export EDITOR="nvim"
export VISUAL="$EDITOR"
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# History
export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=50000
export SAVEHIST=50000

# -----------------------------------------------------------------------------
# Shell Options
# -----------------------------------------------------------------------------
setopt AUTO_CD                   # Type directory name to cd into it

# -----------------------------------------------------------------------------
# History Options
# -----------------------------------------------------------------------------
setopt EXTENDED_HISTORY          # Write the history file in the ':start:elapsed;command' format
setopt HIST_EXPIRE_DUPS_FIRST    # Expire a duplicate event first when trimming history
setopt HIST_FIND_NO_DUPS         # Do not display a previously found event
setopt HIST_IGNORE_ALL_DUPS      # Delete an old recorded event if a new event is a duplicate
setopt HIST_IGNORE_DUPS          # Do not record an event that was just recorded again
setopt HIST_IGNORE_SPACE         # Do not record an event starting with a space
setopt HIST_SAVE_NO_DUPS         # Do not write a duplicate event to the history file
setopt SHARE_HISTORY             # Share history between all sessions

# -----------------------------------------------------------------------------
# Key Bindings
# -----------------------------------------------------------------------------
bindkey -e  # Use emacs keybindings

# -----------------------------------------------------------------------------
# Aliases
# -----------------------------------------------------------------------------
# Navigation
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

# List files (using eza)
alias ls="eza"
alias ll="eza -la --icons --git"
alias la="eza -a"
alias l="eza -l --icons"
alias tree="eza --tree --icons"

# Git
alias g="git"
alias gs="git status"
alias gst="git status"
alias ga="git add"
alias gaa="git add --all"
alias gc="git commit"
alias gcm="git commit -m"
alias gca="git commit --amend"
alias gp="git push"
alias gpf="git push --force-with-lease"
alias gl="git pull"
alias gd="git diff"
alias gds="git diff --staged"
alias gco="git checkout"
alias gcb="git checkout -b"
alias gb="git branch"
alias gba="git branch -a"
alias gbd="git branch -d"
alias glog="git log --oneline --graph --decorate"
alias glo="git log --oneline -10"
alias grb="git rebase"
alias grbi="git rebase -i"
alias gsta="git stash"
alias gstp="git stash pop"
alias gm="git merge"
alias gf="git fetch"
alias gr="git remote -v"

# Editor
alias vim="nvim"
alias v="nvim"
alias lg="lazygit"
alias lzd="lazydocker"

# Directories
alias dev="cd ~/Code"
alias dotfiles="cd ~/Code/infra/dotfiles"

# Utilities
alias reload="source ~/.zshrc"
alias path='echo -e ${PATH//:/\\n}'
alias myip="curl -s https://ipinfo.io/ip"
alias cat="bat"
alias catp="bat -p"  # plain, no line numbers

# macOS specific
alias showfiles="defaults write com.apple.finder AppleShowAllFiles YES && killall Finder"
alias hidefiles="defaults write com.apple.finder AppleShowAllFiles NO && killall Finder"
alias flushdns="sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder"

# -----------------------------------------------------------------------------
# Functions
# -----------------------------------------------------------------------------
# Create a new directory and enter it
mkcd() {
    mkdir -p "$@" && cd "$_"
}

# Extract various archive formats
extract() {
    if [ -f "$1" ]; then
        case "$1" in
            *.tar.bz2)   tar xjf "$1"     ;;
            *.tar.gz)    tar xzf "$1"     ;;
            *.bz2)       bunzip2 "$1"     ;;
            *.rar)       unrar x "$1"     ;;
            *.gz)        gunzip "$1"      ;;
            *.tar)       tar xf "$1"      ;;
            *.tbz2)      tar xjf "$1"     ;;
            *.tgz)       tar xzf "$1"     ;;
            *.zip)       unzip "$1"       ;;
            *.Z)         uncompress "$1"  ;;
            *.7z)        7z x "$1"        ;;
            *)           echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# -----------------------------------------------------------------------------
# Completions
# -----------------------------------------------------------------------------
autoload -Uz compinit
compinit

# Case insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# -----------------------------------------------------------------------------
# Starship Prompt
# -----------------------------------------------------------------------------
eval "$(starship init zsh)"

# -----------------------------------------------------------------------------
# Additional Tool Initialization
# -----------------------------------------------------------------------------
# Node Version Manager (if installed)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# FZF (if installed)
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Zoxide (smarter cd)
eval "$(zoxide init zsh)"

# Thefuck (command correction)
eval "$(thefuck --alias)"

# Zsh Syntax Highlighting (must be last)
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null
