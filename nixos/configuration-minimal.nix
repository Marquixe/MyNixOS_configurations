# Minimal configuration — Hyprland + essentials only.
# Faster first build, useful for a new machine or recovery.
#
# NOT wired into flake.nix yet — to use it, add to flake.nix:
#   nixosConfigurations.minimal = nixpkgs.lib.nixosSystem {
#     system = "x86_64-linux";
#     modules = [ ./nixos/configuration-minimal.nix home-manager... ];
#   };
# then: sudo nixos-rebuild switch --flake .#minimal

{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  nix.settings = {
    log-lines           = 50;
    max-jobs            = "auto";
    auto-optimise-store = true;
  };

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
  networking.hostName              = "thinkpadik";
  networking.wireless.enable       = false;
  networking.networkmanager.enable = true;

  networking.firewall = {
    enable                = true;
    logRefusedConnections = true;
  };

  # ── Core services ─────────────────────────────────────────────────────────
  # programs.kdeconnect.enable = true;  # enable if you use KDE Connect
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

  # services.desktopManager.plasma6.enable = true;  # heavy, skip for minimal

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
    layout  = "us,ua";
    variant = ",";
    options = "grp:alt_shift_toggle";
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

  services.journald.extraConfig = ''
    SystemMaxUse=500M
    MaxRetentionSec=2week
  '';

  # virtualisation.docker = { ... };  # enable when you need containers
  # programs.wireshark.enable = true; # enable when you need packet capture

  # ── Shell ─────────────────────────────────────────────────────────────────
  programs.zsh.enable    = true;
  users.defaultUserShell = pkgs.zsh;

  # ── User ──────────────────────────────────────────────────────────────────
  users.users.markie = {
    isNormalUser = true;
    description  = "D`artagnan";
    extraGroups  = [
      "networkmanager"
      "wheel"
      "audio"
      "video"
      # "docker"    # uncomment when docker is enabled
    ];
  };

  programs.firefox.enable = true;

  # ── System packages ───────────────────────────────────────────────────────
  environment.systemPackages = with pkgs; [

    # ── SDDM theme ────────────────────────────────────────────────────────
    (sddm-astronaut.override { embeddedTheme = "pixel_sakura"; })

    # ── Hyprland / Wayland system deps ────────────────────────────────────
    xdg-utils
    xdg-desktop-portal-hyprland
    glib
    gtk3
    libinput

    # ── Fonts ─────────────────────────────────────────────────────────────
    nerd-fonts.jetbrains-mono

    # ── Essentials only ───────────────────────────────────────────────────
    git
    wget
    curl
    vim
    btop
    nix-output-monitor
    nh
  ];

  system.stateVersion = "25.11";
}
