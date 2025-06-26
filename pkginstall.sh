echo "📦 Installing official repo packages..."

LIST_DIR="$HOME/.dotfiles/pkglists/"

for list in "$LIST_DIR"/*.txt; do
  name=$(basename "$list")
  if [[ "$name" != aur* ]]; then
    echo "→ Installing from $name"
    grep -vE '^\s*#|^\s*$' "$list" | sudo pacman -S --needed --noconfirm -
  fi
done

echo "Done! 🎉"

