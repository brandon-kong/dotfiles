#!/usr/bin/env bash

set -e

DOTFILES_DIR="$HOME/.dotfiles"

# List of dotfiles to symlink: "source:target"
DOTFILES=(
  "$DOTFILES_DIR/vim/.vimrc:$HOME/.vimrc"
  "$DOTFILES_DIR/git/.gitconfig:$HOME/.gitconfig"
  "$DOTFILES_DIR/zsh/.zshrc:$HOME/.zshrc"
  "$DOTFILES_DIR/zsh/.p10k.zsh:$HOME/.p10k.zsh"
  "$DOTFILES_DIR/tmux/.tmux.conf:$HOME/.tmux.conf"
)

echo "Symlinking dotfiles..."

for entry in "${DOTFILES[@]}"; do
  IFS=":" read -r src dest <<< "$entry"

  if [[ -e "$dest" && ! -L "$dest" ]]; then
    echo "⚠️  Skipping $dest — already exists and is not a symlink"
    continue
  fi

  # Remove existing symlink
  if [[ -L "$dest" ]]; then
    rm "$dest"
  fi

  ln -s "$src" "$dest"
  echo "✅ Linked $dest → $src"
done


echo "📦 Installing official repo packages..."

LIST_DIR="$HOME/.dotfiles/pkglists/"

for list in "$LIST_DIR"/*.txt; do
  name=$(basename "$list")
  if [[ "$name" != aur* ]]; then
    echo "→ Installing from $name"
    grep -vE '^\s*#|^\s*$' "$list" | sudo pacman -S --needed --noconfirm -
  fi
done

echo "📁 Moving scripts to ~/.local/bin..."

# Ensure destination exists
mkdir -p "$HOME/.local/bin"

# Move and rename scripts (remove .sh extension)
for script in "$DOTFILES_DIR/scripts/"*.sh; do
  base=$(basename "$script" .sh)
  dest="$HOME/.local/bin/$base"
  echo "→ Installing $base"
  cp "$script" "$dest"
  chmod +x "$dest"
done

echo "Done! 🎉"
