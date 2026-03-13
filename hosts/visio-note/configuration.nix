{ config, lib, pkgs, username, my_feed_notification, swaylock-wrapper, ... }:

let
  gdk = pkgs.google-cloud-sdk.withExtraComponents
    (with pkgs.google-cloud-sdk.components; [ gke-gcloud-auth-plugin ]);

in {
  imports = [ ./hardware-configuration.nix ];

  LucasNT.system = {
    addAllPackgesForNvim = true;
    isBtrfs = true;
    isServer = false;
    isNotebook = true;
    enableBackup = true;
    enableDocker = true;
    enableSSHD = true;
    enableQmk = true;
    username = username;
    extraEnvironmentPackage = [ ];
    extraFonts = [ ];
    extraUserPackages = with pkgs; [
      bitwarden-cli
      borgbackup
      chromium
      devenv
      discord
      gh
      gdk
      helix
      jira-cli-go
      kubectl
      jujutsu
      logseq
      my_feed_notification
      neovim
      nushell
      obsidian
      pika-backup
      ripgrep
      sox
      swaylock-wrapper
      wireguard-tools
    ];
  };

  LucasNT.update.enable = true;

  services.netbird.enable = true;

  fileSystems."/home/lucas/NAS" = {
    device = "192.168.189.10:/files/Lucas";
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

  nix.extraOptions = ''
    extra-substituters = https://devenv.cachix.org
    extra-trusted-public-keys = devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=
  '';

  nixpkgs = {
    config = {
      allowUnfreePredicate = pkg:
        builtins.elem (lib.getName pkg) [
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

  system.stateVersion = "24.11";

}
