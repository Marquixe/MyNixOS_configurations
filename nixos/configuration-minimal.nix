# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running 'nixos-help').

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      /etc/nixos/hardware-configuration.nix
    ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  nix.settings = {
    log-lines            = 50;
    download-buffer-size = 10485760;
    http-connections     = 50;
    max-jobs             = "auto";
    auto-optimise-store  = true;
  };

  # ── Nix garbage collection ────────────────────────────────────────────────
  nix.gc = {
    automatic = true;
    dates     = "weekly";
    options   = "--delete-older-than 14d";
  };

  swapDevices = [
    { device = "/swapfile"; }
  ];

  boot.kernel.sysctl = {
    "vm.swappiness"             = 10;
    "vm.dirty_ratio"            = 15;
    "vm.dirty_background_ratio" = 5;
    "kernel.dmesg_restrict"     = 0;
  };

  # ── Bootloader ────────────────────────────────────────────────────────────
  boot.loader.systemd-boot.enable             = true;
  boot.loader.efi.canTouchEfiVariables        = true;
  boot.loader.systemd-boot.configurationLimit = 10;

  # ── Networking ────────────────────────────────────────────────────────────
  networking.hostName                    = "thinkpadik";
  networking.wireless.enable             = false;
  networking.networkmanager.enable       = true;
  networking.networkmanager.wifi.backend = "wpa_supplicant";

  # ── Firewall ──────────────────────────────────────────────────────────────
  networking.firewall = {
    enable                = true;
    logRefusedConnections = true;
  };

  # ── Core services ─────────────────────────────────────────────────────────
  # programs.kdeconnect.enable          = true;   # enable if you use KDE Connect mobile app
  security.polkit.enable              = true;
  services.gnome.gnome-keyring.enable = true;
  services.dbus.enable                = true;

  # ── Hyprland ──────────────────────────────────────────────────────────────
  programs.hyprland = {
    enable          = true;
    xwayland.enable = true;
    withUWSM        = true;
  };

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # ── Display manager ───────────────────────────────────────────────────────
  services.displayManager.sddm = {
    enable         = true;
    wayland.enable = true;
    theme          = "sddm-astronaut-theme";
    extraPackages  = with pkgs; [
      sddm-astronaut
      qt6.qtmultimedia
      qt6.qt5compat
    ];
  };

  # ── KDE Plasma (backup session) ───────────────────────────────────────────
  # services.desktopManager.plasma6.enable = true;  # heavy, skip for minimal install

  # ── Time & locale ─────────────────────────────────────────────────────────
  time.timeZone      = "Europe/Bratislava";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS        = "sk_SK.UTF-8";
    LC_IDENTIFICATION = "sk_SK.UTF-8";
    LC_MEASUREMENT    = "sk_SK.UTF-8";
    LC_MONETARY       = "sk_SK.UTF-8";
    LC_NAME           = "sk_SK.UTF-8";
    LC_NUMERIC        = "sk_SK.UTF-8";
    LC_PAPER          = "sk_SK.UTF-8";
    LC_TELEPHONE      = "sk_SK.UTF-8";
    LC_TIME           = "sk_SK.UTF-8";
  };

  services.xserver.enable = true;
  services.xserver.xkb = {
    layout  = "us";
    variant = "";
  };

  # ── Sound ─────────────────────────────────────────────────────────────────
  services.pulseaudio.enable = false;
  security.rtkit.enable      = true;
  services.pipewire = {
    enable            = true;
    alsa.enable       = true;
    alsa.support32Bit = true;
    pulse.enable      = true;
  };

  # services.printing.enable = true;  # enable if you need printing

  # ── Journal tuning ────────────────────────────────────────────────────────
  services.journald.extraConfig = ''
    SystemMaxUse=500M
    MaxRetentionSec=2week
    MaxLevelStore=debug
  '';

  # ── Docker ────────────────────────────────────────────────────────────────
  # virtualisation.docker = {         # enable when you need containers
  #   enable           = true;
  #   autoPrune.enable = true;
  # };

  # ── Wireshark ─────────────────────────────────────────────────────────────
  # programs.wireshark.enable = true; # enable when you need packet capture

  # ── Default shell → zsh ───────────────────────────────────────────────────
  programs.zsh.enable    = true;
  users.defaultUserShell = pkgs.zsh;

  # ── direnv ────────────────────────────────────────────────────────────────
  # programs.direnv = {               # enable when doing dev work
  #   enable            = true;
  #   nix-direnv.enable = true;
  # };

  # ── User ──────────────────────────────────────────────────────────────────
  users.users.markie = {
    isNormalUser = true;
    description  = "D`artagnan";
    extraGroups  = [
      "networkmanager"
      "wheel"
      "audio"
      "video"
      # "docker"      # uncomment when docker is enabled
      # "wireshark"   # uncomment when wireshark is enabled
    ];
    packages = with pkgs; [
      # kdePackages.kate   # kate editor, skip for minimal
      thunderbird
    ];
  };

  programs.firefox.enable = true;

  # ── System packages ───────────────────────────────────────────────────────
  environment.systemPackages = with pkgs; [

    # ── SDDM theme ────────────────────────────────────────────────────────
    (sddm-astronaut.override { embeddedTheme = "pixel_sakura"; })

    # ── Hyprland ecosystem ────────────────────────────────────────────────
    kitty
    wofi
    hyprpaper
    hyprlock
    hypridle
    grimblast
    dunst
    wl-clipboard
    xdg-utils
    xdg-desktop-portal-hyprland
    cliphist
    brightnessctl
    wlogout
    glib
    gtk3

    # ── Fonts ─────────────────────────────────────────────────────────────
    nerd-fonts.jetbrains-mono
    # nerd-fonts.fira-code   # uncomment if needed
    # nerd-fonts.hack        # uncomment if needed

    # ── Editors ───────────────────────────────────────────────────────────
    vim
    neovim
    # vscode                 # large download, add when settled
    # jetbrains.pycharm-oss  # very large, add when needed

    # ── Terminal & shell ──────────────────────────────────────────────────
    zsh
    starship
    zoxide
    fzf
    bat
    eza
    # delta    # git diff pager, add with lazygit setup
    # tmux     # add when needed
    yazi

    # ── File & text tools ─────────────────────────────────────────────────
    tree
    fd
    ripgrep
    jq
    unzip
    zip
    # ranger   # add if you prefer ranger over yazi
    # sd       # add when needed
    # yq       # add when needed
    # p7zip    # add when needed
    # rsync    # add when needed

    # ── Git ───────────────────────────────────────────────────────────────
    git
    gh
    lazygit

    # ── Network ───────────────────────────────────────────────────────────
    wget
    curl
    # httpie      # add when needed
    # nmap        # add when needed
    # dig         # add when needed
    # whois       # add when needed
    # traceroute  # add when needed
    # mtr         # add when needed
    # bandwhich   # add when needed
    # nethogs     # add when needed
    # nload       # add when needed
    # iftop       # add when needed

    # ── Process & system visibility ───────────────────────────────────────
    btop
    # htop      # btop covers this
    # bottom    # add if you prefer
    # procs     # add if you prefer
    # lsof      # add when debugging
    # strace    # add when debugging
    # ltrace    # add when debugging
    # sysstat   # add when needed
    # iotop     # add when needed

    # ── Disk & storage ────────────────────────────────────────────────────
    # dust          # add when needed
    duf
    # smartmontools # add for disk health checks
    # nvme-cli      # add for NVMe specific tools
    stow

    # ── Hardware & diagnostics ────────────────────────────────────────────
    # pciutils    # add when needed
    # usbutils    # add when needed
    # dmidecode   # add when needed
    # powertop    # add for battery tuning
    # acpi        # add for battery info
    # stress-ng   # add for stress testing

    # ── Log & error visibility ────────────────────────────────────────────
    # lnav      # add when needed
    # grc       # add when needed
    # multitail # add when needed

    # ── Build progress ────────────────────────────────────────────────────
    nix-output-monitor
    # pv        # add when needed
    # progress  # add when needed

    # ── Nix helpers ───────────────────────────────────────────────────────
    # nix-tree  # add when auditing closures
    # nix-du    # add when auditing closures
    # nvd       # add when diffing generations
    nh

    # ── Dev tools ─────────────────────────────────────────────────────────
    # gnumake       # add when building C projects
    # gcc           # add when building C projects
    # python3       # add when doing Python work
    # nodejs        # add when doing JS work
    # docker-compose # add with docker
    # direnv        # add with direnv service above
    # nix-direnv    # add with direnv service above
    # dive          # add with docker

    # ── Fun / info ────────────────────────────────────────────────────────
    fastfetch
    # cmatrix      # add for fun
    # asciiquarium # add for fun
    # toilet       # add for fun
    # tty-clock    # add for fun

    # ── Media ─────────────────────────────────────────────────────────────
    # spotify  # large, add when settled

  ];

  system.stateVersion = "25.11";
}
