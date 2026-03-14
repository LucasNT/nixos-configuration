{ config, lib, pkgs, username, swaylock-wrapper, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  LucasNT.system = {
    isBtrfs = true;
    isServer = false;
    isNotebook = true;
    enableDocker = true;
    enableSSHD = true;
    enableQmk = true;
    addAllPackgesForNvim = true;
    username = username;
    extraEnvironmentPackage = [ ];
    bootKernelParams = [ "resume_offset=4233897" ];
    extraFonts = [ ];
    extraUserPackages = with pkgs; [
      bitwarden-cli
      borgbackup
      devenv
      discord
      gh
      helix
      jujutsu
      logseq
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

  boot = {
    resumeDevice = "/dev/disk/by-uuid/3c9e7185-0144-4202-a90d-4d856493250f";
  };

  fileSystems."/home/ringo/NAS" = {
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
  nix.extraOptions = ''
    extra-substituters = https://devenv.cachix.org
    extra-trusted-public-keys = devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=
  '';

  nixpkgs = { # precisa de mais configuração
    config = {
      allowUnfreePredicate = pkg:
        builtins.elem (lib.getName pkg) [
          "discord-canary"
          "steam"
          "steam-unwrapped"
          "obsidian"
        ];
    };
  };

  programs = { steam.enable = true; };

  services = {
    logind = { settings.Login.HandleLidSwitch = lib.mkForce "HybridSleep"; };
    upower = { criticalPowerAction = lib.mkForce "HybridSleep"; };
    rpcbind.enable = true; # não sei se é necessário
  };

  system.stateVersion = "24.11";

}
