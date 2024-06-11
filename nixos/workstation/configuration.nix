{ hostName, domain, timeZone, pkgs, ... }:
{

  i18n.supportedLocales = [ "all" ];
  powerManagement.powertop.enable = true;
  programs.light.enable = true;
  time.timeZone = timeZone;
  boot.supportedFilesystems = [ "ntfs" ];
  boot.kernelModules = [
    "i2c-dev" # enables ddcutil for monitor brightness
  ];
  boot.kernelParams = [
    "usbcore.autosuspend=-1" # fix peripherals auto-sleeping after boot
  ];

  # GC #################################################################
  nix.gc = {
    automatic = true;
    options = "-d";
  };
  nix.optimise.automatic = true;

  # Audio ############################################################
  sound.enable = false; # disable ALSA-based configuration
  security.rtkit.enable = true; # for PulseAudio to acquire realtime priority
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Bluetooth ########################################################
  hardware.bluetooth.enable = false;

  # Networking #########################################################
  networking = {
    hostName = hostName;
    domain = domain;
    wireless.enable = true;
    firewall.enable = true;
  };

  # Packages ###########################################################
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = [
    pkgs.pavucontrol
    pkgs.nvi
    pkgs.vimHugeX
  ];

  # Sudoers ############################################################
  security.sudo.extraRules = [
    {
      groups = [ "wheel" ];
      commands =
        map
          (x:
            {
              command = "/run/current-system/sw/bin/${x}";
              options = [ "SETENV" "NOPASSWD" ];
            }
          )
          [
            "nix-channel"
            "nix-collect-garbage"
            "nixos-rebuild"
            "reboot"
            "shutdown"
            "systemctl"
          ];
    }
  ];

  # Services ###########################################################
  services.cron.enable = true;
  services.fail2ban.enable = true;
  services.gpm.enable = true;
  services.openssh.enable = false;
  services.udisks2.enable = true;

  # X11 ##############################################################
  services.xserver = {
    enable = true;
    xkb.layout = "us";
    windowManager.xmonad.enable = true;
    windowManager.xmonad.enableContribAndExtras = true;
    desktopManager.xterm.enable = false;
    synaptics.enable = false;
  };
  services.displayManager.defaultSession = "none+xmonad";

  # Printing #########################################################
  services.printing = {
    enable = true;
    drivers = [
      pkgs.brgenml1cupswrapper
      pkgs.brgenml1lpr
    ];
  };

  # Fonts ##############################################################
  fonts = {
    packages = [
      pkgs.dejavu_fonts
      pkgs.ubuntu_font_family
    ];
  };

  ## Docker ############################################################
  virtualisation.docker.enable = true;

}
