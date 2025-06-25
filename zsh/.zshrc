export ZSH="/home/brandon/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(git zsh-vi-mode)

source $ZSH/oh-my-zsh.sh

# History location
HISTFILE=$HOME/.config/zsh/history
HISTSIZE=10000
SAVEHIST=10000

# Extra config
export EDITOR=nvim
