# Minimal home-manager config — pairs with nixos/configuration-minimal.nix.
# Only what is needed for a working Hyprland desktop + shell.
# Full setup lives in home.nix (large package list, editors, games, etc.).
{ config, pkgs, ... }:

{
    home.username      = "markie";
    home.homeDirectory = "/home/markie";
    home.stateVersion  = "25.11";

    programs.home-manager.enable = true;

    programs.zsh = {
        enable = true;
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;
        enableCompletion = true;
        initContent = builtins.readFile ./zsh/.zshrc;
    };

    home.packages = with pkgs; [
        # desktop
        kitty
        wofi
        hyprpaper
        mako
        libnotify
        brightnessctl
        playerctl
        # screenshots / clipboard
        grim
        slurp
        grimblast
        swappy
        wl-clipboard
        cliphist
        clipse
        # tools used by hypr/tools
        fzf
        networkmanager
        # essentials
        git
        neovim
        ripgrep
        fd
        eza
        bat
        zoxide
        starship
    ];

    xdg.configFile = {
        "hypr/hyprland.lua".source  = ./hypr/hyprland.lua;
        "hypr/hyprpaper.conf".source = ./hypr/hyprpaper.conf;

        "hypr/tools/monitor-extend.sh"   = { source = ./hypr/tools/monitor-extend.sh;   executable = true; };
        "hypr/tools/monitor-mirror.sh"   = { source = ./hypr/tools/monitor-mirror.sh;   executable = true; };
        "hypr/tools/workspaces-split.sh" = { source = ./hypr/tools/workspaces-split.sh; executable = true; };
        "hypr/tools/zoom.sh"             = { source = ./hypr/tools/zoom.sh;             executable = true; };
        "hypr/tools/toggle-showkeys.sh"  = { source = ./hypr/tools/toggle-showkeys.sh;  executable = true; };
        "hypr/tools/wifi.sh"             = { source = ./hypr/tools/wifi.sh;             executable = true; };
        "hypr/tools/toggle-player.sh"    = { source = ./hypr/tools/toggle-player.sh;    executable = true; };
        "hypr/tools/spotify-player.sh"   = { source = ./hypr/tools/spotify-player.sh;   executable = true; };

        "mako/config"      .source = ./mako/config;
        "mako/vol.sh"      = { source = ./mako/vol.sh;      executable = true; };
        "mako/brightness.sh" = { source = ./mako/brightness.sh; executable = true; };
        "mako/battery-notify.sh" = { source = ./mako/battery-notify.sh; executable = true; };
        "kitty/kitty.conf" .source = ./kitty/kitty.conf;
        "wofi/style.css"   .source = ./wofi/style.css;
        "swappy/config"    .source = ./swappy/config;
        "starship.toml"    .source = ./starship/starship.toml;
    };

    home.file."Pictures/wallpapers/mi_background.jpg".source = ../wallpapers/mi_background.jpg;
}
