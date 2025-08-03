{ config, lib, pkgs, username, dwl_local, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  LucasNT.system = {
    isBtrfs = true;
    isServer = true;
    isNotebook = false;
    enableDocker = true;
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
    ];
  };

  fileSystems."/files/Lucas" = {
    device = "/dev/disk/by-uuid/b0f49523-ab2d-4c9a-9364-831463616ebe";
    fsType = "btrfs";
    options = [ "subvol=@Lucas" ];
  };

  fileSystems."/files/backup-note" = {
    device = "/dev/disk/by-uuid/b0f49523-ab2d-4c9a-9364-831463616ebe";
    fsType = "btrfs";
    options = [ "subvol=@backup-note" ];
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
    nfs.server = {
      enable = true;
      exports = ''
        /files/Lucas 192.168.133.9(rw,nohide,subtree_check) 192.168.133.8(rw,nohide,subtree_check) 192.168.133.4(rw,nohide,subtree_check)
      '';
    };

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

  networking.firewall.allowedTCPPorts = [ 2049 ];
}
