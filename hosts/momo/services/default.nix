{ config, lib, pkgs, ... }: {
  imports = [
    ./alloy.nix
    ./memos.nix
    ./transmission.nix
    ./navidrome.nix
    ./copyparty.nix
    ./traefik.nix
  ];
}
