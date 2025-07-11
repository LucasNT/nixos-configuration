{ config, lib, pkgs, ... }:
let cfg = config.LucasNT.system;
in {
  options.LucasNT.system = {
    isBtrfs = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Indicate that the system uses btrfs as filesystem";
    };

    isServer = lib.mkEnableOption "is a server machine";

    isNotebook = lib.mkEnableOption "is a notebook";

    enableSSHD = lib.mkEnableOption "Enable SSHD service";

    username = lib.mkOption {
      type = lib.types.str;
      description = "Username of the user of the machine";
    };

    extraEnvironmentPackage = lib.mkOption {
      type = lib.types.listOf lib.types.packages;
      default = [ ];
      description = "List of extra packages for system environment";
    };

    bootKernelParams = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Kernel Parameters";
    };

    extraFonts = lib.mkOption {
      type = lib.types.listOf lib.types.packages;
      default = [ ];
      description = "Extra fonts to install in the system";
    };

  };

  config = {
    boot = {
      kernelParams = [ ] ++ cfg.boot.kernelParams;
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

    fonts = lib.mkIf cfg.isServer == false {
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

    i18n.defaultLocale = "pt_BR.UTF-8";

    programs = { git.enable = true; };

    nix = {
      settings.experimental-features = [ "nix-command" "flakes" ];
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 7d";
        persistent = true;
      };
    };

    security = {
      polkit.enable = true;
      rtkit.enable = true;
    };

    time.timeZone = lib.mkDefault "America/Sao_Paulo";

    imports = [ ../hosts/base/services/openssh.nix ];

  };
}
