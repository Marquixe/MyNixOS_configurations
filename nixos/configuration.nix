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

  #swapDevices = [
  #  { device = "/swapfile"; }
  #];

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
  programs.kdeconnect.enable          = true;
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
  services.desktopManager.plasma6.enable = true;

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

  services.printing.enable = true;

  # ── Journal tuning ────────────────────────────────────────────────────────
  services.journald.extraConfig = ''
    SystemMaxUse=500M
    MaxRetentionSec=2week
    MaxLevelStore=debug
  '';

  # ── Docker ────────────────────────────────────────────────────────────────
  virtualisation.docker = {
    enable           = true;
    autoPrune.enable = true;
  };

  # ── Virtualisation ────────────────────────────────────────────────────────
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package  = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;   # needed for Windows 11 TPM
    };
  };

  programs.virt-manager.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;  # USB passthrough

  # ── Wireshark ─────────────────────────────────────────────────────────────
  programs.wireshark.enable = true;

  # ── Default shell → zsh ───────────────────────────────────────────────────
  programs.zsh.enable    = true;
  users.defaultUserShell = pkgs.zsh;

  # ── direnv ────────────────────────────────────────────────────────────────
  programs.direnv = {
    enable            = true;
    nix-direnv.enable = true;
  };

  # ── User ──────────────────────────────────────────────────────────────────
  users.users.markie = {
    isNormalUser = true;
    description  = "D`artagnan";
    extraGroups  = [
      "networkmanager"
      "wheel"
      "audio"
      "video"
      "docker"
      "wireshark"
      "libvirtd"
    ];
    packages = with pkgs; [
      kdePackages.kate
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
    adwaita-icon-theme

    # ── Fonts ─────────────────────────────────────────────────────────────
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    nerd-fonts.hack

    # ── Editors ───────────────────────────────────────────────────────────
    vim
    neovim
    vscode
    jetbrains.pycharm-oss

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
    stow               # HAVE THIS BEFORE INSTALL.SH

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

    #  ── Virtualisation ───────────────────────────────────────────────────
    virt-manager
    virt-viewer
    dnsmasq      # needed for VM networking
    virtiofsd    # folder sharing between host and VM

    # ── Fun / info ────────────────────────────────────────────────────────
    fastfetch
    cmatrix
    asciiquarium
    toilet
    tty-clock

    # ── Media ─────────────────────────────────────────────────────────────
    spotify

  ];

  system.stateVersion = "25.11";
}
