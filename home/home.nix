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

  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zathura = {
    enable = true;
    options = {
        recolor = "true";
        # "recolor-lightcolor" = "#ebdbb2"; # warm paper bg
        # "recolor-darkcolor" = "#282828";  # warm paper fg
        "recolor-lightcolor" = "#1e1e2e";
        "recolor-darkcolor" = "#cdd6f4";
        "recolor-keephue" = "false";
    };
  };


  # ── Conf lins → ~/.config/ ──────────────────────────────────────────────────
  xdg.configFile = {
    # nvim
    #"nvim".source 		   = ./nvim;
    #"nvim".source          = config.lib.file.mkOutOfStoreSymlink "/home/markie/dotfiles/home/nvim";

    # hypr
    "hypr/hyprland.conf".source    = ./hypr/hyprland.conf;
    "hypr/hyprpaper.conf".source   = ./hypr/hyprpaper.conf;
    #hypr hud
    "hypr/hud.sh"         = { source = ./hypr/hud.sh;         executable = true; };
    "hypr/hud-date.sh"    = { source = ./hypr/hud-date.sh;    executable = true; };
    "hypr/hud-stats.sh"   = { source = ./hypr/hud-stats.sh;   executable = true; };
    "hypr/hud-updates.sh" = { source = ./hypr/hud-updates.sh; executable = true; };

    # mako
    "mako/config".source           = ./mako/config;
    "mako/battery-notify.sh"       = { source = ./mako/battery-notify.sh; executable = true; };
    "mako/vol.sh"                  = { source = ./mako/vol.sh; executable = true; };

    # kitty
    "kitty/kitty.conf".source      = ./kitty/kitty.conf;

    # wofi
    "wofi/style.css".source        = ./wofi/style.css;

    # wlogout
    "wlogout/style.css".source     = ./wlogout/style.css;

    # starship
    "starship.toml".source              = ./starship/starship.toml; 
    "starship-python.toml".source       = ./starship/starship-python.toml;
    "starship-java.toml".source         = ./starship/starship-java.toml;
  };


  home.file.".config/nvim" = {
    source = config.lib.file.mkOutOfStoreSymlink "/home/markie/dotfiles/home/nvim";
    recursive = false;
  };

  home.file = {
    #".zshrc".source = ./zsh/.zshrc;
    "Pictures/wallpapers/mi_background.jpg".source = ../wallpapers/mi_background.jpg;
  };

  # ── Packets ────────────────────────────────────────────────────────────────

  home.packages = with pkgs; [

    # ── Hyprland ecosystem ────────────────────────────────────────────────
    kitty
    wofi
    hyprpaper
    hyprlock
    hypridle
    grimblast
    dunst
    wl-clipboard
    cliphist
    brightnessctl
    wlogout
    mako
    libnotify

    # ── Editors ───────────────────────────────────────────────────────────
    vim
    neovim
    vscode
    jetbrains.pycharm-oss
    xournalpp
    nodejs
    tree-sitter

    clang-tools
    pyright
    ruff
    jdt-language-server
    jdk
    lua-language-server


    ollama
    claude-code

    # ── Terminal & shell ──────────────────────────────────────────────────
    zsh
    starship
    zoxide
    fzf
    bat
    eza
    delta
    tmux
    yazi
    atuin

    # ── File & text tools ─────────────────────────────────────────────────
    ranger
    tree
    fd
    ripgrep
    sd
    jq
    yq
    unzip
    zip
    p7zip
    rsync
    gnupg

    # zathura

    # ── Git ───────────────────────────────────────────────────────────────
    git
    gh
    lazygit

    # ── Network ───────────────────────────────────────────────────────────
    wget
    curl
    httpie
    nmap
    dig
    whois
    traceroute
    mtr
    bandwhich
    nethogs
    nload
    iftop

    # ── Process & system visibility ───────────────────────────────────────
    btop
    htop
    bottom
    procs
    lsof
    strace
    ltrace
    sysstat
    iotop

    # ── Disk & storage ────────────────────────────────────────────────────
    dust
    duf
    smartmontools
    nvme-cli
    gptfdisk
    efibootmgr
    parted

    # ── Hardware & diagnostics ────────────────────────────────────────────
    pciutils
    usbutils
    dmidecode
    powertop
    acpi
    stress-ng

    # ── Log & error visibility ────────────────────────────────────────────
    lnav
    grc
    multitail

    # ── Build progress ────────────────────────────────────────────────────
    nix-output-monitor
    pv
    progress

    # ── Nix helpers ───────────────────────────────────────────────────────
    nix-tree
    nix-du
    nvd
    nh

    # ── Dev tools ─────────────────────────────────────────────────────────
    gnumake
    gcc
    python3
    nodejs
    docker-compose
    direnv
    nix-direnv
    dive

    # ── Fun / terminal art ────────────────────────────────────────────────
    fastfetch
    asciiquarium
    cmatrix
    cbonsai
    pipes
    sl
    lavat
    genact
    hollywood
    mapscii
    fortune
    snowmachine
    gping
    tty-clock
    toilet
    figlet
    lolcat
    cowsay
    jp2a
    libcaca
    tplay

    # ── Media ─────────────────────────────────────────────────────────────
    spotify

    # ── KDE apps ──────────────────────────────────────────────────────────
    kdePackages.kate
    thunderbird
  ];
}
