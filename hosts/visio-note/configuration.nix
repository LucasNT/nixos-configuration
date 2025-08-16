{ config, lib, pkgs, username, dwl_local, my_feed_notification, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  LucasNT.system = {
    isBtrfs = true;
    isServer = false;
    isNotebook = true;
    enableBackup = true;
    enableDocker = true;
    enableSSHD = true;
    username = username;
    extraEnvironmentPackage = [ ];
    bootKernelParams = [ "resume_offset=1158954" ];
    extraFonts = [ ];
    extraUserPackages = with pkgs; [
      borgbackup
      chromium
      discord-canary
      gh
      google-cloud-sdk
      logseq
      my_feed_notification
      neovim
      nushell
      obsidian
      pika-backup
      ripgrep
      sox
      wireguard-tools
    ];
  };

  boot = {
    resumeDevice = "/dev/disk/by-uuid/7ef084d0-c6b8-4264-a677-37f0d2e6a913";
  };

  fileSystems."/home/lucas/NAS" = {
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

  networking = {
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
          "obsidian"
        ];
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

}
