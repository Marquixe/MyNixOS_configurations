# ══════════════════════════════════════════════════════════════════════════════
#  ~/.zshrc  —  markie @ thinkpadik
# ══════════════════════════════════════════════════════════════════════════════
export PATH="$HOME/.local/bin:$PATH"

# ── History ───────────────────────────────────────────────────────────────────
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_DUPS       # don't save duplicate commands
setopt HIST_IGNORE_SPACE      # commands starting with a space aren't saved
setopt SHARE_HISTORY          # share history across all open terminals
setopt AUTO_CD                # type a directory name to cd into it
setopt CORRECT                # suggest corrections for mistyped commands

# ── Completion ────────────────────────────────────────────────────────────────
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select                        # arrow-key menu
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'      # case-insensitive
zstyle ':completion:*:descriptions' format '%F{yellow}── %d ──%f'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"  # coloured completions

# ── Starship prompt ───────────────────────────────────────────────────────────
eval "$(starship init zsh)"

# ── zoxide (smarter cd) ───────────────────────────────────────────────────────
eval "$(zoxide init zsh)"

# ── fzf  ──────────────────────────────────────────────────────────────────────
source <(fzf --zsh)                        # Ctrl+R = fuzzy history search
                                           # Ctrl+T = fuzzy file picker
export FZF_DEFAULT_OPTS="
  --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8
  --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc
  --color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8
  --border rounded --prompt '  ' --pointer '' --marker ''
"
# use fd for fzf file finding (respects .gitignore, much faster)
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# ── Colours ───────────────────────────────────────────────────────────────────
export LS_COLORS="$(vivid generate catppuccin-mocha 2>/dev/null)"  # optional: install vivid
export CLICOLOR=1

# ── Better defaults ───────────────────────────────────────────────────────────
export EDITOR=nvim
export VISUAL=nvim
export PAGER='bat --style=plain'   # bat as man/pager
export MANPAGER="sh -c 'col -bx | bat -l man -p'"  # coloured man pages

# ── Aliases — navigation ──────────────────────────────────────────────────────
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ~='cd ~'

# ── Aliases — ls → eza ────────────────────────────────────────────────────────
alias ls='eza --icons --group-directories-first'
alias ll='eza --icons --group-directories-first -l'
alias la='eza --icons --group-directories-first -la'
alias lt='eza --icons --tree --level=2'
alias lta='eza --icons --tree --level=2 -a'

# ── Aliases — cat → bat ───────────────────────────────────────────────────────
alias cat='bat'
alias cат='bat'   # cyrillic typo guard 😄

# ── Aliases — grep → ripgrep ─────────────────────────────────────────────────
alias grep='rg'

# ── Aliases — find → fd ───────────────────────────────────────────────────────
alias find='fd'

# ── Aliases — git ─────────────────────────────────────────────────────────────
alias g='git'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline --graph --decorate --all'
alias lg='lazygit'

# ── Aliases — system ──────────────────────────────────────────────────────────
alias top='btop'
alias df='duf'
alias du='dust'
alias ps='procs'

# ── Aliases — NixOS ───────────────────────────────────────────────────────────
alias nrf='sudo nixos-rebuild switch --flake ~/dotfiles#thinkpadik'                  # build + apply now + default at boot
alias nrboot='sudo nixos-rebuild boot --flake ~/dotfiles#thinkpadik'                 # apply only after reboot
alias nrtest='sudo nixos-rebuild test --flake ~/dotfiles#thinkpadik |& nom'          # apply now, no boot entry
alias nrollback='sudo nixos-rebuild switch --rollback'                               # back to previous generation
alias ngeneration='sudo nixos-rebuild list-generations'                              # list generations
alias ndiff='nvd diff /run/booted-system /run/current-system'                        # what changed since boot

# flake inputs: "update" only fetches newer versions into flake.lock, applies nothing
alias nfu_all='(cd ~/dotfiles && nix flake update)'                                  # ALL inputs, includes nixpkgs (can break things)
alias nfu_home='(cd ~/dotfiles && nix flake update home-manager)'                    # home-manager only
alias nfu_nixgl='(cd ~/dotfiles && nix flake update nixgl)'                          # nixGL only
alias nfcheck='nix flake check --no-build ~/dotfiles'                                # validate flake, no build

alias ngarbage='sudo nix-collect-garbage -d'        # delete old generations
alias nshell='nix-shell'                          # drop into a nix shell
alias nmetadata= 'nix flake metadata ~/dotfiles'

# ── Aliases — misc ────────────────────────────────────────────────────────────
alias v='nvim'
alias vi='nvim'
alias vim='nvim'
alias c='clear'
alias q='exit'
alias reload='source ~/.zshrc'
alias zshrc='nvim ~/dotfiles/home/zsh/.zshrc'
alias ip='ip --color=auto'
alias diff='delta'                             # better diffs
alias copy='wl-copy <'

alias teachings='cd ~/TEACH_ME_KING/ && clear'

# ── Keybindings ───────────────────────────────────────────────────────────────
bindkey '^[[A' history-search-backward   # Up arrow   → search history
bindkey '^[[B' history-search-forward    # Down arrow → search history
bindkey '^[[H' beginning-of-line         # Home
bindkey '^[[F' end-of-line               # End
bindkey '^[[3~' delete-char              # Delete key

# ── Functions ─────────────────────────────────────────────────────────────────

nrfv() {
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo " NixOS rebuild"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "Command:"
    echo "  sudo nixos-rebuild switch --flake ~/dotfiles#thinkpadik"
    echo ""
	echo "||| dont forget sudo |||"
	echo "vvv                  vvv"
    
    sudo nixos-rebuild switch \
        --flake ~/dotfiles#thinkpadik \
        --show-trace \
		--print-build-logs \
        |& nom
}


# mkcd — make a directory and immediately cd into it
mkcd() { mkdir -p "$1" && cd "$1" }

# extract — extract any archive format
extract() {
  case "$1" in
    *.tar.bz2)  tar xjf "$1"   ;;
    *.tar.gz)   tar xzf "$1"   ;;
    *.tar.xz)   tar xJf "$1"   ;;
    *.zip)      unzip "$1"     ;;
    *.7z)       7z x "$1"      ;;
    *.rar)      unrar x "$1"   ;;
    *.gz)       gunzip "$1"    ;;
    *)          echo "Don't know how to extract '$1'" ;;
  esac
}


# ENVS 


# enter nix dev shells from dotfiles repo
devshell() {
  local shell="$1"
  local repo="$HOME/dotfiles"

  if [[ -z "$shell" ]]; then
    echo "Usage: devshell <shell>"
    return 1
  fi

  nix develop "$repo#$shell" -c zsh
}

# make python venw
mkenv() {
  if [[ -d .venv ]]; then
    echo ".venv already exists"
    return 0
  fi

  command -v python >/dev/null || {
    echo "Python not found (are you in nix shell?)"
    return 1
  }

  python -m venv .venv || return 1
  source .venv/bin/activate || return 1

  python -m pip install --upgrade pip

  if [[ -f requirements.txt ]]; then
    pip install -r requirements.txt
    echo "requirements installed"
  fi

  echo "venv ready"
}

# setup project fast
pysetup() {
  nd python || return 1
  mkenv
}

# auto activate/deactivate python venv
autoenv() {
  local dir="$PWD"

  while [[ "$dir" != "/" ]]; do
    if [[ -f "$dir/.venv/bin/activate" ]]; then
      source "$dir/.venv/bin/activate"
      return
    fi
    dir=$(dirname "$dir")
  done

  if [[ -n "$VIRTUAL_ENV" ]]; then
    deactivate 2>/dev/null
  fi
}

# run on every directory change
autoload -U add-zsh-hook
add-zsh-hook chpwd autoenv

# also run once when shell starts
autoenv


# network shortcuts
wifi() {
  case "$1" in
    list)    nmcli device wifi list ;;
    connect) nmcli device wifi connect "$2" password "$3"
             nmcli connection modify "$2" wifi-sec.psk-flags 0
             nmcli connection modify "$2" connection.permissions "" ;;
    saved)   nmcli connection show ;;
    up)      nmcli connection up "$2" ;;
    down)    nmcli connection down "$2" ;;
    *)       echo "Usage:
  wifi list              — scan for networks
  wifi connect NAME PASS — connect and save permanently
  wifi saved             — show saved networks
  wifi up NAME           — reconnect to saved network
  wifi down NAME         — disconnect" ;;
  esac
}

# copytree — copy project tree to clipboard
# Usage: copytree [eza flags...]
# Examples:
#   copytree
#   copytree -a
#   copytree -a -I .git
#   copytree --level=5
copytree() {
  eza --icons=never --tree --group-directories-first "$@" | wl-copy
  echo "copied"
}

# fcd — fuzzy cd into any subdirectory
fcd() { cd "$(fd --type d | fzf --preview 'eza --tree --level=1 {}')" }

# fv — fuzzy open file in nvim
fv() { nvim "$(fzf --preview 'bat --color=always {}')" }

# sysinfo — quick system snapshot
sysinfo() {
  echo ""
  fastfetch
  echo ""
  duf -only local
  echo ""
}
  
if [[ -z "$DEV_SHELL_NAME" ]]; then
  sysinfo
fi
