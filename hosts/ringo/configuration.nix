{ config, lib, pkgs, username, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../programs/pipewire.nix
    (import ../../programs/docker.nix {
      inherit config lib pkgs;
      btrfsEnable = true;
    })
  ];

  boot = {
    kernelParams = [ "resume_offset=4233897" ];
    resumeDevice = "/dev/disk/by-uuid/3c9e7185-0144-4202-a90d-4d856493250f";
  };

  fileSystems."/home/ringo/Backup" = {
    device = "192.168.133.6:/files/backup-note";
    fsType = "nfs";
    options = [
      "vers=4"
      "x-systemd.automount"
      "x-systemd.mount-timeout=10"
      "x-systemd.idle-timeout=1min"
      "_netdev"
    ];
  };

  hardware = {
    graphics.enable = true;
    bluetooth = {
      enable = true;
      powerOnBoot = false;
    };
  };

  networking.wireless.enable = true;

  nixpkgs = {
    config = {
      allowUnfreePredicate = pkg:
        builtins.elem (lib.getName pkg) [
          "discord-canary"
          "electron-27.3.11"
          "discord"
          "steam"
          "steam-unwrapped"
        ];
      permittedInsecurePackages = [ "electron-27.3.11" ];
    };
  };

  programs = {
    firefox.enable = true;
    hyprlock.enable = true;
    steam.enable = true;
  };

  services = {
    hypridle.enable = true;
    libinput.enable = true;
    logind = {
      lidSwitch = "hibernate";
      lidSwitchDocked = "suspend";
    };
    upower = {
      enable = true;
      enableWattsUpPro = false;
      criticalPowerAction = "Hibernate";
      ignoreLid = false;
      noPollBatteries = true;
      percentageLow = 20;
      percentageCritical = 8;
      percentageAction = 5;
      usePercentageForPolicy = true;
    };
    rpcbind.enable = true;
  };

  users = {
    groups = { wifi_controller = { }; };
    users."${username}" = {
      isNormalUser = true;
      extraGroups = [ "wheel" "wifi_controller" ];
      packages = with pkgs; [
        alacritty
        borgbackup
        brightnessctl
        (callPackage ../../programs/dwlmsg.nix { })
        (callPackage ../../programs/dwl.nix { })
        (callPackage ../../programs/dwl-tag-viewer.nix { })
        curl
        discord
        discord-canary
        dunst
        eww
        gh
        grim
        htop
        logseq
        neovim
        nushell
        playerctl
        ripgrep
        rxvt-unicode
        slurp
        swappy
        tmux
        wget
        wireguard-tools
        wl-clipboard
        wlr-randr
        wofi
        xorg.xrdb
        yadm
        pika-backup
      ];
    };
  };

  xdg.portal = {
    enable = true;
    config = { common.default = "*"; };
    wlr.enable = true;
  };
}
