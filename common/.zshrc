# Enable vim mode
bindkey -v

ZSH_CACHE_DIR="$HOME/.cache/zsh"
ZSH_COMPDUMP="${ZSH_CACHE_DIR}/.zcompdump-${HOST}"
export ZSH_COMPDUMP

HISTFILE=$HOME/.config/zsh/history

# Ensure that the cache directory exists
mkdir -p "${ZSH_CACHE_DIR}"

# Customize VI cursor
export ZVM_CURSOR_STYLE_ENABLED=true
export ZVM_VI_INSERT_MODE_CURSOR='beam'
export ZVM_VI_NORMAL_MODE_CURSOR='block'

# Disable Powerlevel9k config wizard
POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true

# Source OS-specific overrides
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
