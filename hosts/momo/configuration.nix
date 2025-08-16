{ config, lib, pkgs, username, ... }:

{
  imports =
    [ ./hardware-configuration.nix ./file-system-mounts.nix ./containers.nix ];

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

  networking = {
    defaultGateway = "192.168.133.1";
    nameservers = [ "1.1.1.1" ];
    interfaces.enp2s0.ipv4.addresses = [{
      address = "192.168.133.10";
      prefixLength = 24;
    }];
  };

  services = {
    transmission = {
      enable = true;
      package = pkgs.transmission_4;
      openRPCPort = true;
      settings = {
        rpc-bind-address = "0.0.0.0";
        rpc-whitelist = " 127.0.0.1,192.168.133.*";
      };
    };
  };

  system.stateVersion = lib.mkForce "25.05";

  networking.firewall.allowedTCPPorts = [ 2049 5230 ];

}
