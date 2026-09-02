# ~/.zshrc — minimal functional shell config

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY          # share history across all sessions
setopt HIST_IGNORE_DUPS       # don't record duplicate consecutive commands
setopt HIST_IGNORE_SPACE      # don't record commands starting with a space
setopt APPEND_HISTORY         # append to history file, don't overwrite

autoload -Uz compinit
compinit
zstyle ':completion:*' menu select   # arrow-key-navigable completion menu
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'  # case-insensitive matching

if [ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

if [ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
    source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

if command -v starship &> /dev/null; then
    eval "$(starship init zsh)"
fi

# --- Basic quality-of-life ---
export EDITOR=nvim
export VISUAL=nvim
alias ls='eza --icons'          # you have eza installed
alias ll='eza -la --icons'
alias cat='bat 2>/dev/null || cat'  # falls back to plain cat if bat isn't installed

# --- Key bindings for history search ---
bindkey '^R' history-incremental-search-backward
function y() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"

    yazi "$@" --cwd-file="$tmp"

    if [[ -s "$tmp" ]]; then
        local cwd="$(cat "$tmp")"
        if [[ -d "$cwd" && "$cwd" != "$PWD" ]]; then
            cd -- "$cwd"
        fi
    fi

    rm -f -- "$tmp"
}
alias dots='cd ~/dotfiles'
alias stowit='stow --verbose'
alias unstowit='stow --delete --verbose'
alias restowit='stow --restow --verbose'
export PATH="$HOME/.local/bin:$PATH"
