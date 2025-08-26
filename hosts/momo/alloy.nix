{ config, lib, pkgs, ... }:

{
  services.alloy = {
    enable = true;
    configPath = "/home/lucas/config.alloy";
  };

  environment.etc."alloy/config.alloy" = {
    enable = true;
    text = ''
      prometheus.exporter.unix "momo" { }
    '';
  };
}
