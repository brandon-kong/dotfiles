#!/usr/bin/env bash
set -euo pipefail

FONT="JetBrainsMono"
NERD_FONT="$FONT Nerd Font"
INSTALL_DIR="$HOME/.local/share/fonts"

echo "🔤 Installing $NERD_FONT..."

# Detect OS
OS="$(uname -s)"

if [[ "$OS" == "Darwin" ]]; then
  echo "🍎 Detected macOS"

  if ! brew tap | grep -q "homebrew/cask-fonts"; then
    brew tap homebrew/cask-fonts
  fi

  brew install --cask "font-${FONT,,}-nerd-font"  # lowercase
  echo "✅ Installed $NERD_FONT via Homebrew"

elif [[ "$OS" == "Linux" ]]; then
  echo "🐧 Detected Linux"

  # Create fonts dir if needed
  mkdir -p "$INSTALL_DIR"

  # Download from GitHub
  ZIP_NAME="${FONT// /}%20Nerd%20Font.zip"
  DL_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/${FONT// /}%20Nerd%20Font.zip"
  TEMP_ZIP="/tmp/${FONT// /}-Nerd-Font.zip"

  echo "📥 Downloading from $DL_URL"
  curl -L -o "$TEMP_ZIP" "$DL_URL"

  echo "📦 Extracting to $INSTALL_DIR"
  unzip -o "$TEMP_ZIP" -d "$INSTALL_DIR"

  echo "🔁 Refreshing font cache..."
  fc-cache -fv

  echo "✅ Installed $NERD_FONT to $INSTALL_DIR"
else
  echo "❌ Unsupported OS: $OS"
  exit 1
fi

