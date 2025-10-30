{ config, lib, pkgs, ... }:

let cfg = config.LucasNT.qmk;
in {
  options.LucasNT.qmk = { enable = lib.mkEnableOption "Enable QMK"; };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.qmk pkgs.vial ];
    hardware.keyboard.qmk.enable = true;
  };
}
