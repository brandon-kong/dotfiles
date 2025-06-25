#!/bin/bash

echo "Installing dependencies..."
sudo pacman -S --noconfirm zsh git curl

echo "Installing Oh My Zsh..."
export RUNZSH=no
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

ZSH_CUSTOM=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}

echo "Installing plugins..."
git clone https://github.com/jeffreytse/zsh-vi-mode.git $ZSH_CUSTOM/plugins/zsh-vi-mode

echo "Installing Powerlevel10k..."
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k

echo "Configuring .zshrc..."

cat > ~/.zshrc <<EOF
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(git zsh-vi-mode)

source \$ZSH/oh-my-zsh.sh

# History location
HISTFILE=\$HOME/.config/zsh/history
HISTSIZE=10000
SAVEHIST=10000

# Extra config
export EDITOR=nvim
EOF

mkdir -p ~/.config/zsh
touch ~/.config/zsh/history

echo "Changing default shell to zsh..."
chsh -s $(which zsh)

echo "Done! Start a new terminal or run 'zsh' to get started."

