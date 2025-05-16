{ config, lib, pkgs, username, ... }:

{
  imports = [
    ./hardware-configuration.nix
    (import ../../services/docker.nix { inherit config lib pkgs; })
  ];

  users.users."${username}" = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [ wget neovim ];
  };

  programs.git = { enable = true; };

  system.stateVersion = lib.mkForce "24.11";
}
