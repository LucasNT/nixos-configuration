{ config, lib, pkgs, dwl_local, ... }:
let cfg = config.LucasNT.system;
in {
  imports = [ ../hosts/base/services/openssh.nix ./docker.nix ./backup.nix ];
  options.LucasNT.system = {
    isBtrfs = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Indicate that the system uses btrfs as filesystem";
    };

    isServer = lib.mkEnableOption "is a server machine";

    isNotebook = lib.mkEnableOption "is a notebook";

    enableBackup = lib.mkEnableOption "Enable backup configurations";

    enableDocker = lib.mkEnableOption "Enable Docker service";

    enableSSHD = lib.mkEnableOption "Enable SSHD service";

    username = lib.mkOption {
      type = lib.types.str;
      description = "Username of the user of the machine";
    };

    extraEnvironmentPackage = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ ];
      description = "List of extra packages for system environment";
    };

    bootKernelParams = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Kernel Parameters";
    };

    extraFonts = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ ];
      description = "Extra fonts to install in the system";
    };

    extraUserGroups = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "List of extra groups to add user";
    };

    defaultUserPackages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = with pkgs; [ curl htop tmux wget yadm ];
      description = "List of default packages to install in user";
    };

    extraUserPackages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ ];
      description = "List of extra packages to install in  the user";
    };

    addAllPackgesForNvim =
      lib.mkEnableOption "Install packages for development with neovim";

  };

  config = {
    boot = {
      kernelParams = [ ] ++ cfg.bootKernelParams;
      loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
      };
      supportedFilesystems = [ "nfs" ];
      tmp.cleanOnBoot = true;
    };

    console = {
      font = "sun12x22";
      keyMap = "br-abnt2";
    };

    environment.systemPackages = with pkgs;
      [ vim wget curl tmux ] ++ cfg.extraEnvironmentPackage;

    fonts = lib.mkIf (cfg.isServer == false) {
      fontconfig.useEmbeddedBitmaps = true;
      packages = with pkgs;
        [
          liberation_ttf
          fira-code
          fira-code-symbols
          mplus-outline-fonts.githubRelease
          noto-fonts
          dina-font
          proggyfonts
          cascadia-code
        ] ++ cfg.extraFonts;
    };

    hardware.graphics.enable = !cfg.isServer;

    hardware.bluetooth = lib.mkIf cfg.isNotebook {
      enable = true;
      powerOnBoot = false;
    };

    i18n.defaultLocale = lib.mkDefault "pt_BR.UTF-8";

    LucasNT.docker = lib.mkIf cfg.enableDocker {
      enable = true;
      isBtrfs = cfg.isBtrfs;
    };

    LucasNT.backup.enable = true;

    networking.wireless.enable = lib.mkDefault cfg.isNotebook;

    nix.settings.experimental-features = [ "nix-command" "flakes" ];
    nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
      persistent = true;
    };

    programs.git.enable = true;

    programs.firefox.enable = lib.mkDefault (!cfg.isServer);

    programs.niri.enable = !cfg.isServer;

    programs.waybar.enable = !cfg.isServer;

    security = {
      polkit.enable = true;
      rtkit.enable = true;
    };

    services.libinput.enable = !cfg.isServer;

    services.logind = lib.mkIf (cfg.isNotebook) {
      lidSwitch = lib.mkDefault "suspend";
      lidSwitchDocked = lib.mkDefault "suspend";
    };

    services.upower = lib.mkIf (cfg.isNotebook) {
      enable = true;
      enableWattsUpPro = false;
      criticalPowerAction = lib.mkDefault "HybridSleep";
      ignoreLid = false;
      noPollBatteries = true;
      percentageLow = 20;
      percentageCritical = 8;
      percentageAction = 5;
      usePercentageForPolicy = true;
    };

    services.pipewire = lib.mkIf (!cfg.isServer) {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
      jack.enable = true;
      wireplumber = {
        extraConfig = {
          "10-bluez" = {
            "bluez5.enable-sbc-xq" = true;
            "bluez5.enable-msbc" = true;
            "bluez5.enable-hw-volume" = true;
            "bluez5.roles" = [ "a2dp_sink" "a2dp_source" "hsp_hs" "hsp_ag" ];
          };
          "11-bluetooth-policy" = {
            "wireplumber.settings" = {
              "bluetooth.autoswitch-to-headset-profile" = false;
            };
          };
        };
      };
    };

    time.timeZone = lib.mkDefault "America/Sao_Paulo";

    users.groups.wifi_controller = lib.mkDefault { };

    users.users."${cfg.username}" = {
      isNormalUser = true;
      extraGroups = [ "wheel" "wifi_controller" ] ++ cfg.extraUserGroups;
      packages = cfg.defaultUserPackages ++ cfg.extraUserPackages
        ++ (if cfg.isServer then
          [ ]
        else
          with pkgs; [
            alacritty
            brightnessctl
            dunst
            fuzzel
            grim
            playerctl
            rose-pine-cursor
            rxvt-unicode
            slurp
            swappy
            swaybg
            swayidle
            swaylock
            wl-clipboard
            wlr-randr
            xdg-utils
            xorg.xrdb
            xwayland-satellite
          ]) ++ lib.lists.optionals cfg.addAllPackgesForNvim
        (with pkgs; [ nodejs python3 gcc gnumake unzip go cargo ]);
    };

  };
}
