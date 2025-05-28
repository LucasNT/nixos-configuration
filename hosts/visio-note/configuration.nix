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
    kernelParams = [ "resume_offset=1158954" ];
    resumeDevice = "/dev/disk/by-uuid/7ef084d0-c6b8-4264-a677-37f0d2e6a913";
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
        ];
      permittedInsecurePackages = [ "electron-27.3.11" ];
    };
  };

  programs = {
    firefox.enable = true;
    hyprlock.enable = true;
  };

  services = {
    hypridle.enable = true;
    libinput.enable = true;
    logind = {
      lidSwitch = "suspend";
      lidSwitchDocked = "suspend";
    };
    upower = {
      enable = true;
      enableWattsUpPro = false;
      criticalPowerAction = "HybridSleep";
      ignoreLid = false;
      noPollBatteries = true;
      percentageLow = 20;
      percentageCritical = 15;
      percentageAction = 10;
      usePercentageForPolicy = true;
    };
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
        discord-canary
        dunst
        eww
        gh
        google-cloud-sdk
        grim
        htop
        logseq
        neovim
        nushell
        pika-backup
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
        xdg-utils
        xorg.xrdb
        yadm
      ];
    };
  };

  xdg.portal = {
    enable = true;
    config = { common.default = [ "wlr" "gtk" ]; };
    wlr.enable = true;
  };
}
