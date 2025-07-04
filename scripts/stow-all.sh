#!/bin/bash

set -e # Exit on error

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$DOTFILES_DIR/stow"

for dir in *; do
  echo "🔗 Stowing $dir..."
  stow -t "$HOME" "$dir"
done
