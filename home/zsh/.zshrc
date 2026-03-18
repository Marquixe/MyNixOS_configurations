# ══════════════════════════════════════════════════════════════════════════════
#  ~/.zshrc  —  markie @ thinkpadik
# ══════════════════════════════════════════════════════════════════════════════

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
alias nrs='sudo nixos-rebuild switch |& nom'   # rebuild with progress
alias nrb='sudo nixos-rebuild boot |& nom'     # rebuild, apply on next boot
alias nrt='sudo nixos-rebuild test |& nom'     # test without making permanent
alias ngc='sudo nix-collect-garbage -d'        # delete old generations
alias nup='sudo nix flake update'              # update flake inputs
alias nsh='nix-shell'                          # drop into a nix shell

# ── Aliases — misc ────────────────────────────────────────────────────────────
alias v='nvim'
alias vi='nvim'
alias vim='nvim'
alias c='clear'
alias q='exit'
alias reload='source ~/.zshrc'
alias zshrc='nvim ~/.zshrc'
alias ip='ip --color=auto'
alias diff='delta'                             # better diffs
alias copy='wl-copy <'

# ── Keybindings ───────────────────────────────────────────────────────────────
bindkey '^[[A' history-search-backward   # Up arrow   → search history
bindkey '^[[B' history-search-forward    # Down arrow → search history
bindkey '^[[H' beginning-of-line         # Home
bindkey '^[[F' end-of-line               # End
bindkey '^[[3~' delete-char              # Delete key

# ── Functions ─────────────────────────────────────────────────────────────────

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

# makes venv in current proj
mkenv() {
  python3 -m venv .venv
  source .venv/bin/activate
  echo "✔ venv created and activated"
  [[ -f requirements.txt ]] && pip install -r requirements.txt && echo "✔ requirements installed"
}

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
  
sysinfo

