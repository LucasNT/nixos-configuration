{ config, lib, pkgs, ... }:
let cfg = config.LucasNT.system;
in {
  imports =
    [ ../hosts/base/services/openssh.nix ./docker.nix ./backup.nix ./qmk.nix ];
  options.LucasNT.system = {
    isBtrfs = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Indicate that the system uses btrfs as filesystem";
    };

    isNotebook = lib.mkEnableOption "is a notebook";

    enableBackup = lib.mkEnableOption "Enable backup configurations";

    enableDocker = lib.mkEnableOption "Enable Docker service";

    enableSSHD = lib.mkEnableOption "Enable SSHD service";

    enableQmk = lib.mkEnableOption "Enable QMK";

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

    userAuthrorizedKeys = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "List of public keys authorized for the user";
    };

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



    hardware.bluetooth = lib.mkIf cfg.isNotebook {
      enable = true;
      powerOnBoot = false;
    };

    i18n.defaultLocale = lib.mkDefault "pt_BR.UTF-8";

    LucasNT.docker = lib.mkIf cfg.enableDocker {
      enable = true;
      isBtrfs = cfg.isBtrfs;
    };

    LucasNT.backup.enable = cfg.enableBackup;

    LucasNT.qmk.enable = cfg.enableQmk;

    networking.wireless = lib.mkIf cfg.isNotebook {
      enable = true;
      allowAuxiliaryImperativeNetworks = true;
      userControlled = true;
    };

    nix.settings.experimental-features = [ "nix-command" "flakes" ];
    nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
      persistent = true;
    };

    programs.git.enable = true;

    security = {
      polkit.enable = true;
      rtkit.enable = true;
    };

    services.logind = lib.mkIf (cfg.isNotebook) {
      settings.Login.HandleLidSwitch = lib.mkDefault "suspend";
      settings.Login.HandleLidSwitchDocked = lib.mkDefault "ignore";
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

    time.timeZone = lib.mkDefault "America/Sao_Paulo";

    users.groups.wifi_controller = lib.mkDefault { };

    users.users."${cfg.username}" = {
      isNormalUser = true;
      extraGroups = [ "wheel" "wpa_supplicant" ] ++ cfg.extraUserGroups;
      packages = lib.mkMerge [
        cfg.defaultUserPackages
        cfg.extraUserPackages
        (lib.lists.optionals cfg.addAllPackgesForNvim
          (with pkgs; [ nodejs python3 gcc gnumake unzip go cargo nil ]))
      ];
      openssh.authorizedKeys.keys = cfg.userAuthrorizedKeys;
    };


  };
}
