{ config, lib, pkgs, username, dwl_local, ... }:

{
  imports = [
    ./hardware-configuration.nix
    (import ../../programs/docker.nix {
      inherit config lib pkgs;
      btrfsEnable = true;
    })
  ];

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
