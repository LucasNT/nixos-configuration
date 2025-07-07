{ config, lib, pkgs, ... }:

let cfg = config.LucasNT.docker;
in {
  options.LucasNT.docker = {
    enable =
      lib.mkEnableOption "Enable Docker with some pre configured options";
    isBtrfs = lib.mkEnableOption "Enable support to btrfs";
  };
  config = lib.mkIf cfg.enable {
    virtualisation.docker = {
      enable = true;
      storageDriver = if cfg.isBtrfs then "btrfs" else null;
    };
  };
}
