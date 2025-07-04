#!/bin/bash
set -euo pipefail

echo "🍏 Starting macOS dotfiles setup..."

# Get dotfiles root directory
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
BREWFILE="$DOTFILES_DIR/system/mac/Brewfile"

# ------------------------------
# 1. Symlink dotfiles using stow
# ------------------------------
echo "🔗 Stowing dotfiles..."
bash "$DOTFILES_DIR/scripts/stow-all.sh"

# ------------------------------
# 2. Install Homebrew
# ------------------------------
if ! command -v brew &>/dev/null; then
  echo "🍺 Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  echo "✅ Homebrew already installed."
fi

# ------------------------------
# 3. Install Brewfile packages
# ------------------------------
if [ -f "$BREWFILE" ]; then
  echo "📦 Installing packages from Brewfile..."
  brew bundle --file="$BREWFILE"
else
  echo "⚠️  No Brewfile found at $BREWFILE"
fi

# ------------------------------
# 4. Install Oh My Zsh
# ------------------------------
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "⚙️ Installing Oh My Zsh..."
  RUNZSH=no KEEP_ZSHRC=yes sh -c \
    "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
  echo "✅ Oh My Zsh already installed."
fi

# ------------------------------
# 5. Install Zsh Plugins
# ------------------------------
# Powerlevel10k theme
if [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
  echo "🎨 Installing Powerlevel10k..."
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
    "$ZSH_CUSTOM/themes/powerlevel10k"
fi

# zsh-vi-mode plugin
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-vi-mode" ]; then
  echo "📝 Installing zsh-vi-mode..."
  git clone https://github.com/jeffreytse/zsh-vi-mode.git \
    "$ZSH_CUSTOM/plugins/zsh-vi-mode"
fi

# ------------------------------
# 6. Link mac-specific Zsh config
# ------------------------------
if [ -f "$DOTFILES_DIR/stow/shell/.zshrc.local.mac" ]; then
  echo "📄 Linking .zshrc.local.mac → ~/.zshrc.local"
  ln -sf "$DOTFILES_DIR/stow/shell/.zshrc.local.mac" "$HOME/.zshrc.local"
fi

echo "✅ macOS setup complete. Run 'exec zsh' to reload your shell."

