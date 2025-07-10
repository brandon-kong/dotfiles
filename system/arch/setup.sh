#!/bin/bash
set -euo pipefail

echo "🍏 Starting arch dotfiles setup..."

# Get dotfiles root directory
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

# ------------------------------
# 1. Symlink dotfiles using stow
# ------------------------------
echo "🔗 Stowing dotfiles..."
bash "$DOTFILES_DIR/scripts/stow-all.sh"

# Install packages
echo "📦 Installing packages..."

install_from_file() {
  local file="$1"
  [[ ! -f "$file" ]] && echo "⚠️ Package list not found: $file" && return 1

  while IFS= read -r line || [[ -n "$line" ]]; do
    # Remove comments and whitespace
    pkg="$(echo "$line" | sed 's/#.*//' | xargs)"
    [[ -n "$pkg" ]] && echo "➤ $pkg" && sudo pacman -S --noconfirm --needed "$pkg"
  done < "$file"
}

install_from_file "$DOTFILES_DIR/system/arch/pacman-packages.txt"

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
# 6. Link arch-specific Zsh config
# ------------------------------
if [ -f "$DOTFILES_DIR/stow/shell/.zshrc.local.arch" ]; then
  echo "📄 Linking .zshrc.local.arch → ~/.zshrc.local"
  ln -sf "$DOTFILES_DIR/stow/shell/.zshrc.local.arch" "$HOME/.zshrc.local"
fi

echo "✅ arch setup complete. Run 'exec zsh' to reload your shell."

