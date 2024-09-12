{ shareUser, sharePass, stateVersion, pkgs, ... }:
let

  derivations = ../../.;

  nvim-james = import (derivations + "/nvim/james/default.nix") {};

  unison-nix = import (derivations + "/vim/unison/unison.nix") {};

  fswatch = import (derivations + "/fswatch/default.nix") {};
  record = import (derivations + "/record/default.nix") {};

  twofamenu =
    pkgs.writeShellApplication {
      name = "2famenu";
      runtimeInputs = [
        pkgs.pass
        pkgs.oathToolkit
      ];
      text = builtins.readFile ./scripts/2famenu;
    };

  xmobar-vol =
    pkgs.writeShellApplication {
      name = "xmobar-vol";
      runtimeInputs = [
        pkgs.alsa-utils # amixer
      ];
      text = builtins.readFile ./scripts/xmobar-vol.sh;
    };

  xmobar-wifi =
    pkgs.writeShellApplication {
      name = "xmobar-wifi";
      runtimeInputs = [];
      text = builtins.readFile ./scripts/xmobar-wifi.sh;
    };

in {

  imports = [
    <home-manager/nixos> # nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
  ];

  # Samba ##############################################################

  fileSystems."/home/james/share" = {
    device = "//servo/share";
    fsType = "cifs";
    options =
      let
        # prevent hanging on network split
        automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
      in [
        "${automount_opts},uid=1000,gid=100,forceuid,forcegid,username=${shareUser},password=${sharePass},dir_mode=0775,file_mode=0664"
      ];
  };

  # Users ##############################################################

  users.users.james = {
    isNormalUser = true;
    home = "/home/james";
    extraGroups = [
      "adbusers"
      "dialout" # /dev/ttyUSB0 for Baofeng, C.H.I.P.
      "docker"
      "lp" # printer?
      "plugdev" # rtl-sdr
      "vboxusers" # virtualbox
      "video" # light
      "wheel" # sudo
    ];
    openssh.authorizedKeys.keys = [
      builtins.readFile ./id_rsa.pub
    ];
  };

  # Home Manager #######################################################

  home-manager.users.james = {
    home = {
      stateVersion = stateVersion;
      packages = [

        pkgs.alsa-utils
        pkgs.arandr
        pkgs.bat
        pkgs.bind # nslookup
        pkgs.binutils
        pkgs.calibre
        pkgs.cloc
        pkgs.curl
        pkgs.direwolf
        pkgs.dmenu
        pkgs.electrum
        pkgs.ffmpeg
        pkgs.file
        pkgs.firefox
        pkgs.flameshot
        pkgs.geeqie
        pkgs.gimp
        pkgs.gnupg
        pkgs.haskellPackages.ghc
        pkgs.htop
        pkgs.imagemagick
        pkgs.inetutils # telnet
        pkgs.inotify-tools
        pkgs.jdk
        pkgs.jq
        pkgs.killall
        pkgs.libreoffice
        pkgs.links2
        pkgs.lm_sensors
        pkgs.mermaid-cli
        pkgs.mosh
        pkgs.mplayer
        pkgs.musescore
        pkgs.nix-prefetch-git
        pkgs.nmap
        pkgs.nodejs
        pkgs.oathToolkit
        pkgs.pass
        pkgs.pavucontrol
        pkgs.exiftool
        pkgs.pitivi
        pkgs.powertop
        pkgs.rename
        pkgs.rtl-sdr
        pkgs.scala
        pkgs.scrcpy
        pkgs.screen
        pkgs.scrot
        pkgs.simplescreenrecorder
        pkgs.stellarium
        pkgs.tree
        pkgs.unrar
        pkgs.unzip
        pkgs.uqm
        pkgs.wget
        pkgs.which
        pkgs.wpa_supplicant_gui
        pkgs.xclip
        pkgs.xmobar
        pkgs.xorg.libXrandr
        pkgs.xorg.xbacklight
        pkgs.xorg.xhost
        pkgs.xorg.xinit
        pkgs.xorg.xkill
        pkgs.xournal # edit (sign, fill out, etc.) PDFs
        pkgs.zip

        # unison-nix.unison-ucm

        nvim-james

        fswatch
        record
        twofamenu
        xmobar-vol
        xmobar-wifi
      ];
    };

    programs.bash = {
      enable = true;
      bashrcExtra = builtins.readFile ./bash_aliases;
    };

    programs.readline.extraConfig = ''
      set mark-symliked-directories on
    '';

    programs.alacritty = {
      enable = true;
      settings = {
        font = {
          size = 7;
        };
        colors = {
          primary = {
            foreground = "#ffffff";
            background = "#000000";
          };
          normal = {
            black = "#666666";
            red = "#ff6666";
            green = "#66ff66";
            yellow = "#ffff66";
            blue = "#9999ff";
            magenta = "#ff66ff";
            cyan = "#66ffff";
            white = "#cccccc";
          };
          bright = {
            black = "#999999";
            red = "#ff9999";
            green = "#99ff99";
            yellow = "#ffff99";
            blue = "#aaaaff";
            magenta = "#ff99ff";
            cyan = "#99ffff";
            white = "#ffffff";
          };
        };
      };
    };

    programs.xmobar = {
      enable = true;
      extraConfig = builtins.readFile ./xmobarrc;
    };

    programs.git = {
      enable = true;
      userName  = "James Earl Douglas";
      userEmail = "james@earldouglas.com";
      ignores = [
        ".bsp/"
        ".bloop/"
        ".metals/"
        "project/.bloop/"
        "project/metals.sbt"
        "project/project/"
        "target/"
        "result"
      ];
      difftastic.enable = true;
    };

    programs.ssh = {
      enable = true;
      addKeysToAgent = "yes";
      matchBlocks.servo.forwardAgent = true;
    };

    programs.gpg.enable = true;

    xresources.extraConfig = builtins.readFile ./xresources;

    xsession = {
      enable = true;
      profileExtra = ''
        # disable bell
        ${pkgs.xorg.xset}/bin/xset b off

        # screen locker
        ${pkgs.xss-lock}/bin/xss-lock -- ${pkgs.i3lock}/bin/i3lock --color=112244 &

        # screen timeout
        # ${pkgs.xorg.xset}/bin/xset dpms 900 900 900

        # desktop background
        ${pkgs.xorg.xsetroot}/bin/xsetroot -solid black

        # disable touchpad
        ${pkgs.xorg.xinput}/bin/xinput list | \
          grep -Eoi 'touchpad\s*id=[0-9]{1,2}' | \
          grep -Eo '[0-9]{1,2}' | \
          xargs ${pkgs.xorg.xinput}/bin/xinput disable
      '';
      windowManager.xmonad = {
        enable = true;
        enableContribAndExtras = true;
        config = ./xmonad.hs;
      };
    };

    services.ssh-agent.enable = true;

    services.gpg-agent = {
      enable = true;
      extraConfig = ''
        default-cache-ttl 86400
        pinentry-program ${pkgs.pinentry-qt}/bin/pinentry-qt
        allow-loopback-pinentry
      '';
    };
  };
}
