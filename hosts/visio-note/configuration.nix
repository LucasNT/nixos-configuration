{ config, lib, pkgs, username, dwl_local, my_feed_notification, ... }:

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
    (import ../../programs/backup.nix { inherit config lib pkgs; })
  ];

  boot = {
    kernelParams = [ "resume_offset=1158954" ];
    resumeDevice = "/dev/disk/by-uuid/7ef084d0-c6b8-4264-a677-37f0d2e6a913";
  };

  fileSystems."/home/ringo/NAS" = {
    device = "192.168.133.10:/files/Lucas";
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

  networking = {
    wireless.enable = true;
    firewall = {
      allowedTCPPortRanges = [{
        from = 8000;
        to = 10000;
      }];
    };
  };

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

  systemd.user.timers.my_feed_notification = {
    enable = true;
    description = "Timer to test if feed had some problem";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      Unit = "my_feed_notification";
      OnCalendar = "*-*-* *:0/5:*";
    };
  };

  systemd.user.services.my_feed_notification = {
    script = ''
      ${my_feed_notification}/bin/MyFeed https://status.cloud.google.com/en/feed.atom
    '';
    serviceConfig = { Type = "oneshot"; };
  };

  users = {
    groups = { wifi_controller = { }; };
    users."${username}" = {
      isNormalUser = true;
      extraGroups = [ "wheel" "wifi_controller" ];
      packages = with pkgs; [
        borgbackup
        chromium
        curl
        discord-canary
        gh
        google-cloud-sdk
        htop
        logseq
        my_feed_notification
        neovim
        nushell
        pika-backup
        ripgrep
        sox
        tmux
        wget
        wireguard-tools
        yadm
      ];
    };
  };

}
