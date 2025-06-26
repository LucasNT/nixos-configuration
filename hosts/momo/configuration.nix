{ config, lib, pkgs, username, dwl_local, ... }:

{
  imports = [
    ./hardware-configuration.nix
    (import ../../programs/docker.nix {
      inherit config lib pkgs;
      btrfsEnable = true;
    })
  ];

  fileSystems."/files/Lucas" = {
    device = "/dev/disk/by-uuid/b0f49523-ab2d-4c9a-9364-831463616ebe";
    fsType = "btrfs";
    options = [ "subvol=@Lucas" ];
  };

  users = {
    users."${username}" = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      packages = with pkgs; [
        curl
        htop
        neovim
        nushell
        ripgrep
        tmux
        wget
        wireguard-tools
      ];
    };
  };
}
