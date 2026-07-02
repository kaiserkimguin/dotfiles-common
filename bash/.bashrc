# If not running interactively, don't do anything
[[ $- != *i* ]] && return

HISTCONTROL=ignoreboth
shopt -s histappend
HISTSIZE=1000
HISTFILESIZE=2000
shopt -s checkwinsize

if [ -x /usr/bin/dircolors ]; then
  eval "$(dircolors -b ~/.dircolors 2>/dev/null || dircolors -b)"
  alias ls='ls --color=auto'
  alias grep='grep --color=auto'
fi

alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias ..='cd ..'
alias sbash='source ~/.bashrc'
alias nbash='nvim ~/.bashrc'

if ! shopt -oq posix; then
  [ -f /usr/share/bash-completion/bash_completion ] && . /usr/share/bash-completion/bash_completion ||
    [ -f /etc/bash_completion ] && . /etc/bash_completion
fi

# --- Drop-ins (machine-specific extras, e.g. Omarchy) ---
for f in ~/.bashrc.d/*.sh; do
  [ -r "$f" ] && source "$f"
done

# --- PATH ---
export PATH="$HOME/.local/bin:$PATH"
export PATH="$PATH:/usr/local/go/bin"
export PATH="$PATH:$HOME/go/bin"

# --- SSH ---
if command -v keychain &>/dev/null; then
  eval "$(keychain --eval --quiet ~/.ssh/id_ed25519)"
else
  eval "$(ssh-agent -s)" >/dev/null
  ssh-add ~/.ssh/id_ed25519 2>/dev/null
fi

# --- Vi mode ---
set -o vi

# --- Syntax highlighting (ble.sh, if installed) ---
[[ -f ~/.local/share/blesh/ble.sh ]] && source ~/.local/share/blesh/ble.sh

# --- Homebrew setup ---
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv bash)"

# --- direnv setup ---
eval "$(direnv hook bash)"

# ---Autojump---
[[ -s /home/kaiserkimguin/.autojump/etc/profile.d/autojump.sh ]] && source /home/kaiserkimguin/.autojump/etc/profile.d/autojump.sh

# ---zoxide---
eval "$(zoxide init bash)"

# ---starship---
eval "$(starship init bash)"
alias starshipGruvbox='starship preset gruvbox-rainbow -o ~/.config/starship.toml'
alias starshipCat='starship preset catppuccin-powerline -o ~/.config/starship.toml'
alias starshipJetpack='starship preset jetpack -o ~/.config/starship.toml'
alias starshipPastel='starship preset pastel-powerline -o ~/.config/starship.toml'
alias starshipTokyo='starship preset tokyo-night -o ~/.config/starship.toml'
alias starshipPure='starship preset pure-preset -o ~/.config/starship.toml'
# --- go path ---
export PATH=$PATH:$HOME/.local/opt/go/bin
