{ config, lib, pkgs, ... }:

{
  networking.firewall.allowedTCPPorts = [ 1514 ];
  services.alloy = {
    enable = true;
    configPath = "/home/config.alloy";
    extraFlags =
      [ "--server.http.listen-addr=127.0.0.1:12346" "--disable-reporting" ];
  };

  environment.etc."alloy/config.alloy" = {
    enable = true;
    text = ''
      prometheus.exporter.unix "momo" { }
    '';
  };
}
