#!/usr/bin/env bash
# install.sh — restore everything on a fresh NixOS install
set -e

DOTFILES="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

#echo "── NixOS config ─────────────────────────────────────────"
#sudo cp "$DOTFILES/nixos/configuration.nix" /etc/nixos/configuration.nix
#sudo cp "$DOTFILES/nixos/hardware-configuration.nix" /etc/nixos/hardware-configuration.nix
#echo "  copied to /etc/nixos/"

echo "── NixOS config ─────────────────────────────────────────"
sudo rm -f /etc/nixos/configuration.nix
sudo rm -f /etc/nixos/hardware-configuration.nix
sudo ln -s "$DOTFILES/nixos/configuration.nix" /etc/nixos/configuration.nix
sudo ln -s "$DOTFILES/nixos/hardware-configuration.nix" /etc/nixos/hardware-configuration.nix
echo "  linked to /etc/nixos/"

echo "── Stowing dotfiles ──────────────────────────────────────"
cd "$DOTFILES"
for pkg in hypr zsh starship wofi wlogout kitty; do
  if [ -d "$pkg" ]; then
    stow --restow "$pkg"
    echo "  stowed: $pkg"
  else
    echo "  skipped (not found): $pkg"
  fi
done

echo ""
echo "── Done! ─────────────────────────────────────────────────"
echo "  Now run: "
echo "         sudo nixos-rebuild switch |& nom"
echo "         source ~/.zshrc"
echo "         hyprctl reload"
