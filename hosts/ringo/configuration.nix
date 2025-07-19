{ config, lib, pkgs, username, dwl_local, ... }:

{
  imports = [
    ../../modules/baseSystem.nix
    ./hardware-configuration.nix
    (import ../../programs/backup.nix { inherit config lib pkgs; })
  ];

  LucasNT.system = {
    isBtrfs = true;
    isServer = false;
    isNotebook = true;
    enableDocker = true;
    enableSSHD = true;
    username = username;
    extraEnvironmentPackage = [ ];
    bootKernelParams = [ "resume_offset=4233897" ];
    extraFonts = [ ];
    extraUserPackages = with pkgs; [
      borgbackup
      discord-canary
      gh
      logseq
      neovim
      nushell
      pika-backup
      ripgrep
      sox
      wireguard-tools
    ];
  };

  boot = {
    resumeDevice = "/dev/disk/by-uuid/3c9e7185-0144-4202-a90d-4d856493250f";
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

  nixpkgs = { # precisa de mais configuração
    config = {
      allowUnfreePredicate = pkg:
        builtins.elem (lib.getName pkg) [
          "discord-canary"
          "steam"
          "steam-unwrapped"
        ];
    };
  };

  programs = { steam.enable = true; };

  services = {
    logind = { lidSwitch = lib.mkForce "hibernate"; };
    upower = { criticalPowerAction = lib.mkForce "Hibernate"; };
    rpcbind.enable = true; # não sei se é necessário
  };

  system.stateVersion = "24.11";

}
