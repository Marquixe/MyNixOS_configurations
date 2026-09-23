{ config, pkgs, ... }:

let
    wiv = pkgs.stdenv.mkDerivation {
        pname = "wiv";
        version = "unstable";

        src = pkgs.fetchFromGitHub {
            owner = "0xWal";
            repo = "wiv";
            rev = "master";
            sha256 = "sha256-YD6EngIOutRl4ylLqmn6p5uoMnEqOeWnYXYI3K4WwdU=";
        };

        nativeBuildInputs = with pkgs; [ meson ninja pkg-config wayland-scanner ];
        buildInputs = with pkgs; [ cairo libinput pango systemd wayland wayland-protocols libxkbcommon ];
    };

    karel-the-robot = pkgs.stdenv.mkDerivation {
        pname = "karel-the-robot";
        version = "unstable";

        src = pkgs.fetchgit {
            url = "https://git.kpi.fei.tuke.sk/kpi/karel-the-robot.git";
            rev = "6893067cb23d011d45b04ac8b5eb78310583ce02";
            sha256 = "sha256-s2k5iWGwzgQxXjpYVocFc6iBQmPYdrflNNieXGyeUKI=";
        };

        nativeBuildInputs = with pkgs; [ cmake pkg-config ];
        buildInputs = with pkgs; [ ncurses check ];

        cmakeFlags = [ "-DCMAKE_POLICY_VERSION_MINIMUM=3.5" "-DBUILD_TESTING=OFF" ];

        postInstall = ''
            ln -s ${pkgs.ncurses}/lib/libncurses.so $out/lib/libcurses.so
        '';
    };
in
{
    home.username      = "markie";
    home.homeDirectory = "/home/markie";
    home.stateVersion  = "25.11";

    home.sessionPath = [ "$HOME/.local/bin" ];
    home.sessionVariables = {
        C_INCLUDE_PATH  = "${karel-the-robot}/include:${pkgs.ncurses.dev}/include";
        LIBRARY_PATH    = "${karel-the-robot}/lib:${pkgs.ncurses}/lib";
        LD_LIBRARY_PATH = "${karel-the-robot}/lib:${pkgs.ncurses}/lib";
    };

    # home.sessionVariables = {
    #     GRIMBLAST_EDITOR = "swappy";
    # };


    # ── PROGRAMS ─────────────────────────────────────────────────────────────────────────────────
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

    programs.firefox = {
        enable = true;
        profiles.markie = {
            isDefault = true;
            settings = {
                "browser.ctrlTab.sortByRecentlyUsed" = true;
            };
        };
    };


    # ── CONFIG FILES ─────────────────────────────────────────────────────────────────────────────
    # ── Conf lins → ~/.config/ ───────────────────────────────────────────────────────────────────
    xdg.configFile = {
        # nvim
        # "nvim".source    = ./nvim;
        # "nvim".source   = config.lib.file.mkOutOfStoreSymlink "/home/markie/dotfiles/home/nvim";

        # hypr
        "hypr/hyprland.conf".source    = ./hypr/hyprland.conf;
        "hypr/hyprpaper.conf".source   = ./hypr/hyprpaper.conf;
        #hypr hud
        "hypr/hud.sh"         = { source = ./hypr/hud.sh;         executable = true; };
        "hypr/hud-date.sh"    = { source = ./hypr/hud-date.sh;    executable = true; };
        "hypr/hud-stats.sh"   = { source = ./hypr/hud-stats.sh;   executable = true; };
        "hypr/hud-updates.sh" = { source = ./hypr/hud-updates.sh; executable = true; };

        "hypr/spotify-player.sh" = { source = ./hypr/spotify-player.sh; executable = true; };
        "hypr/toggle-player.sh"  = { source = ./hypr/toggle-player.sh;  executable = true; };
        "hypr/wifi.sh"           = { source = ./hypr/wifi.sh;           executable = true; };

        # "hypr/ask-claude.sh"  = { source = ./hypr/ask-claude.sh;  executable = true; };
        # "hypr/ask-claude.py"  = { source = ./hypr/ask-claude.py;  executable = true; };

        # mako
        "mako/config".source           = ./mako/config;
        "mako/battery-notify.sh"       = { source = ./mako/battery-notify.sh; executable = true; };
        "mako/vol.sh"                  = { source = ./mako/vol.sh; executable = true; };
        "mako/brightness.sh"           = { source = ./mako/brightness.sh; executable = true; };
        "mako/set-alarm.sh"            = { source = ./mako/set-alarm.sh; executable = true; };

        # kitty
        "kitty/kitty.conf".source      = ./kitty/kitty.conf;

        # wofi
        "wofi/style.css".source        = ./wofi/style.css;

        # clipse
        "clipse/config.json".source    = ./clipse/config.json;

        # wlogout
        "wlogout/style.css".source     = ./wlogout/style.css;

        # starship
        "starship.toml".source              = ./starship/starship.toml; 
        "starship-python.toml".source       = ./starship/starship-python.toml;
        "starship-java.toml".source         = ./starship/starship-java.toml;

        "swappy/config".source         = ./swappy/config;
        "hypr/zoom.sh"                 = { source = ./hypr/zoom.sh;        executable = true; };
        "hypr/toggle-showkeys.sh"      = { source = ./hypr/toggle-showkeys.sh; executable = true; };



        "clangd/config.yaml".text = ''
            CompileFlags:
                Add:
                    - -I${karel-the-robot}/include
                    - -I${pkgs.ncurses.dev}/include
        '';
    };


    home.file.".config/nvim" = {
        source = config.lib.file.mkOutOfStoreSymlink "/home/markie/dotfiles/home/nvim";
        recursive = false;
    };

    home.file = {
        #".zshrc".source = ./zsh/.zshrc;
        "Pictures/wallpapers/mi_background.jpg".source = ../wallpapers/mi_background.jpg;

        ".local/bin/alarm" = {
            source     = ./mako/set-alarm.sh;
            executable = true;
        };

		".local/bin/scilab" = {
        	text = ''
            	#!/usr/bin/env bash
            	exec env MESA_GL_VERSION_OVERRIDE=2.1 nixGLIntel ${pkgs.scilab-bin}/bin/scilab "$@"
        	'';
        	executable = true;
    	};
    };



    # ── PACKETS ──────────────────────────────────────────────────────────────────────────────────
    home.packages = with pkgs; [
        # ── Hyprland ecosystem ───────────────────────────────────────────────────────────────────
        kitty
        wofi
        hyprpaper
        hyprlock
        hypridle
        grimblast
        swappy
        gimp
        wl-clipboard
        cliphist
        clipse
        chafa
        brightnessctl
        wlogout
        mako
        libnotify
        wiv
		nixgl.nixGLIntel

        # ── Editors ──────────────────────────────────────────────────────────────────────────────
        vim
        neovim
        vscode
        jetbrains.pycharm-oss
		#jetbrains.webstorm
        xournalpp
        tree-sitter
		scilab-bin

        # ── Editor tools ─────────────────────────────────────────────────────────────────────────
        clang-tools
        pyright
        ruff
        jdt-language-server
        jdk
        lua-language-server

        # ── LLM ──────────────────────────────────────────────────────────────────────────────────
        ollama
        claude-code

        # ── Terminal & shell ─────────────────────────────────────────────────────────────────────
        # zsh
        starship
        zoxide
        fzf
        bat
        eza
        delta
        tmux
        yazi
        # atuin
        wine
        winetricks


        # ── Remote desktop ───────────────────────────────────────────────────────────────────────
        moonlight-qt
        cifs-utils
        samba

        # ── File & text tools ────────────────────────────────────────────────────────────────────
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
        imv

        # zathura

        # ── Git ──────────────────────────────────────────────────────────────────────────────────
        git
        gh
        lazygit

        # ── Network ──────────────────────────────────────────────────────────────────────────────
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

        # ── Process & system visibility ──────────────────────────────────────────────────────────
        bc
        btop
        htop
        bottom
        procs
        lsof
        strace
        ltrace
        sysstat
        iotop

        # ── Disk & storage ───────────────────────────────────────────────────────────────────────
        dust
        duf
        smartmontools
        nvme-cli
        gptfdisk
        efibootmgr
        parted

        # ── Hardware & diagnostics ───────────────────────────────────────────────────────────────
        pciutils
        usbutils
        dmidecode
        powertop
        acpi
        stress-ng

        # ── Log & error visibility ───────────────────────────────────────────────────────────────
        lnav
        grc
        multitail

        # ── Build progress ───────────────────────────────────────────────────────────────────────
        nix-output-monitor
        pv
        progress

        # ── Nix helpers ──────────────────────────────────────────────────────────────────────────
        nix-tree
        nix-du
        nvd
        nh

        # ── Dev tools ────────────────────────────────────────────────────────────────────────────
        gnumake
        gcc
        python3
        nodejs
        docker-compose
        # direnv
        # nix-direnv
        dive

        # ── Fun / terminal art ───────────────────────────────────────────────────────────────────
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


        discord
        blender

        # ── Music ────────────────────────────────────────────────────────────────────────────────
        spotify
        playerctl

        # ── KDE apps ─────────────────────────────────────────────────────────────────────────────
        kdePackages.kate
        thunderbird


        # ── Schooling ────────────────────────────────────────────────────────────────────────────
        gdb
        valgrind
        cgdb
        cppcheck
        ncurses
        pkg-config
        check
        karel-the-robot
    ];
}
