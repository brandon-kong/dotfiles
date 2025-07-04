#!/bin/bash

set -e # Exit on error


DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

echo "🔗 Stowing common dotfiles..."
stow -d "$DOTFILES_DIR" -t "$HOME" common

echo "🔗 Stowing mac-specific dotfiles..."
stow -d "$DOTFILES_DIR" -t "$HOME" mac

# Install Oh My Zsh if not present
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "⚙️ Installing Oh My Zsh..."
    RUNZSH=no KEEP_ZSHRC=yes sh -c \
        "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# Install Powerlevel10k theme
if [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
    echo "🎨 Installing Powerlevel10k..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
        "$ZSH_CUSTOM/themes/powerlevel10k"
else
    echo "🎨 Powerlevel10k already installed."
fi

# Install zsh-vi-mode plugin
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-vi-mode" ]; then
    echo "📝 Installing zsh-vi-mode..."
    git clone https://github.com/jeffreytse/zsh-vi-mode.git \
        "$ZSH_CUSTOM/plugins/zsh-vi-mode"
else
    echo "📝 zsh-vi-mode already installed."
fi

stow -d "$DOTFILES_DIR" -t "$HOME" mac

echo "🍺 Installing Homebrew packages..."

if ! command -v brew >/dev/null 2>&1; then
  echo "🧪 Homebrew not found. Installing..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"  # For Apple Silicon
fi

brew bundle --file="$DOTFILES_DIR/brew/Brewfile"

echo "✅ Setup complete. Restart your terminal or run 'exec zsh'."
