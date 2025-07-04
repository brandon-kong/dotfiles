#!/bin/bash
set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

OS="$(uname -s)"

if [[ "$OS" == "Darwin" ]]; then
  echo "🍏 Detected macOS"
  bash "$DOTFILES_DIR/system/mac/setup.sh"
elif [[ -f /etc/arch-release ]]; then
  echo "🐧 Detected Arch Linux"
  bash "$DOTFILES_DIR/system/arch/setup.sh"
else
  echo "❌ Unsupported OS: $OS"
  exit 1
fi

