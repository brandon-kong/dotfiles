# Enable vim mode
bindkey -v

ZSH_CACHE_DIR="$HOME/.cache/zsh"
ZSH_COMPDUMP="${ZSH_CACHE_DIR}/.zcompdump-${HOST}"
export ZSH_COMPDUMP

HISTFILE=$HOME/.config/zsh/history

# Also ensure that the HISTFILE exists
mkdir -p "${HISTFILE:h}"

# Ensure that the cache directory exists
mkdir -p "${ZSH_CACHE_DIR}"

# Customize VI cursor
export ZVM_CURSOR_STYLE_ENABLED=true
export ZVM_VI_INSERT_MODE_CURSOR='beam'
export ZVM_VI_NORMAL_MODE_CURSOR='block'

# Disable Powerlevel9k config wizard
POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true

export XDG_CACHE_HOME="$HOME/.cache/p10k"

mkdir -p "$HOME/.cache/p10k"

# Source instant prompt if it exists
if [[ -r "${XDG_CACHE_HOME}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Source OS-specific overrides
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

# Source all files from .zsh
ZSH_EXTRA_DIR="$HOME/.zsh"

if [[ -d $ZSH_EXTRA_DIR ]]; then
  for file in "$ZSH_EXTRA_DIR"/*.zsh; do
    [[ -r "$file" ]] && source "$file"
  done
fi

# Node configs
export NODE_REPL_HISTORY="$HOME/.cache/node/.node_repl_history"

mkdir -p "$(dirname "$NODE_REPL_HISTORY")"
