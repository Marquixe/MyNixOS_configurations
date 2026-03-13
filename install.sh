#!/usr/bin/env bash
# install.sh — restore everything on a fresh NixOS install
set -e

DOTFILES="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

#echo "── NixOS config ─────────────────────────────────────────"
#sudo cp "$DOTFILES/nixos/configuration.nix" /etc/nixos/configuration.nix
#sudo cp "$DOTFILES/nixos/hardware-configuration.nix" /etc/nixos/hardware-configuration.nix
#echo "  copied to /etc/nixos/"

echo "── NixOS config ─────────────────────────────────────────"

echo "  [1] full     — everything (docker, wireshark, all tools)"
echo "  [2] minimal  — Hyprland + essentials only (faster first build)"
echo ""
read -rp "  Choose [1/2]: " choice
 
case "$choice" in
  2)
    CONFIG_FILE="nixos/configuration-minimal.nix"
    echo "  Using minimal config"
    ;;
  *)
    CONFIG_FILE="nixos/configuration.nix"
    echo "  Using full config"
    ;;
esac

sudo rm -f /etc/nixos/configuration.nix
sudo ln -s "$DOTFILES/$CONFIG_FILE" /etc/nixos/configuration.nix
echo "  linked to /etc/nixos/"

echo "── Stowing dotfiles ──────────────────────────────────────"
cd "$DOTFILES"
for pkg in hypr zsh starship wofi wlogout kitty; do
  if [ -d "$pkg" ]; then
    stow --restow --adopt "$pkg" && git checkout -- .
    echo "  stowed: $pkg"
  else
    echo "  skipped (not found): $pkg"
  fi
done

mkdir -p ~/Pictures/wallpapers
cp -r "$DOTFILES/wallpapers/." ~/Pictures/wallpapers/


echo ""
echo "── Done! ─────────────────────────────────────────────────"
echo "  Now run: "
echo "         sudo nixos-rebuild switch |& nom"
echo "         "
echo "         source ~/.zshrc"
echo "         hyprctl reload"
