# 1. скопіюй hardware-configuration
sudo nixos-generate-config --show-hardware-config > nixos/hardware-configuration.nix

# 2. перевір що флейк читається (нічого не будує, просто парсить)
nix flake show

# 3. якщо ок — запускай
sudo nixos-rebuild switch --flake .#thinkpadik |& nom
