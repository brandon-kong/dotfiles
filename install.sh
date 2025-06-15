#!/usr/bin/env bash

set -e

DOTFILES_DIR="$HOME/.dotfiles"

# List of dotfiles to symlink: "source:target"
DOTFILES=(
  "$DOTFILES_DIR/vim/.vimrc:$HOME/.vimrc"
  "$DOTFILES_DIR/git/.gitconfig:$HOME/.gitconfig"
  "$DOTFILES_DIR/zsh/.zshrc:$HOME/.zshrc"
  "$DOTFILES_DIR/zsh/.p10k.zsh:$HOME/.p10k.zsh"
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

echo "Done! 🎉"
