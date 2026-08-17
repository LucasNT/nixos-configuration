{ config, lib, pkgs, simple-go-uploader-file, ... }:

{
  systemd.services."game-file-uploader" = {
    after = ["network-online.target"];
    wantedBy = [ "multi-user.target" ];
    enable = true;
    serviceConfig = {
      Type = "simple";
      User = "lucas";
      ExecStart = "${simple-go-uploader-file}/bin/simple-go-uploader-file --rootFolder /files/media/jogos";
    };
  };
}
