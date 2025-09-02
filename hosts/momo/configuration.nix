{ config, lib, pkgs, username, ... }:

{
  imports =
    [ ./hardware-configuration.nix ./file-system-mounts.nix ./services ];

  LucasNT.system = {
    isBtrfs = true;
    isServer = true;
    isNotebook = false;
    enableDocker = false;
    enableSSHD = true;
    addAllPackgesForNvim = false;
    username = username;
    extraEnvironmentPackage = [ ];
    extraUserGroups = [ "wheel" "transmission" ];
    extraUserPackages = with pkgs; [
      neovim
      nushell
      ripgrep
      wireguard-tools
      borgbackup
    ];
    userAuthrorizedKeys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPjkvko0b7IhhwM1YzRc7HlUUCPMUboSz2LBC7N5+Zwx lucas@note"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHeYxkpdwq35zwgDChLJ02H9ui9DYjXDEsXHM70IWBD7 lucas@lucasnt"
    ];
  };

  users.groups.media = {
    gid = 2005;
    members = [ "lucas" ];
  };

  system.stateVersion = lib.mkForce "25.05";

  networking.firewall.allowedTCPPorts = [ 2049 ];

}
