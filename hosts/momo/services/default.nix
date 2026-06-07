{ config, lib, pkgs, ... }: {
  imports = [
    ./alloy.nix
    ./memos.nix
    ./transmission.nix
    ./navidrome.nix
    ./copyparty.nix
    ./traefik.nix
    ./static-web-server.nix
    ./jellyfin.nix
    ./garage.nix
    ./mongodb.nix
  ];
}
