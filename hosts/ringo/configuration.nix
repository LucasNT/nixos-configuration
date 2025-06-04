{ config, lib, pkgs, username, dwl_local, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../programs/pipewire.nix
    (import ../../programs/docker.nix {
      inherit config lib pkgs;
      btrfsEnable = true;
    })
    (import ../../programs/desktop.nix {
      inherit config lib pkgs username;
      dwl = dwl_local;
    })
  ];

  boot = {
    kernelParams = [ "resume_offset=4233897" ];
    resumeDevice = "/dev/disk/by-uuid/3c9e7185-0144-4202-a90d-4d856493250f";
  };

  fileSystems."/home/ringo/NAS" = {
    device = "192.168.133.6:/files/Lucas";
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
    steam.enable = true;
  };

  services = {
    logind = {
      lidSwitch = "suspend";
      lidSwitchDocked = "suspend";
    };
    upower = {
      enable = false;
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
        borgbackup
        curl
        discord
        discord-canary
        gh
        htop
        logseq
        neovim
        nushell
        pika-backup
        ripgrep
        tmux
        wget
        wireguard-tools
        yadm
      ];
    };
  };

}
