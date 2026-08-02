{ config, lib, pkgs, simple-go-uploader-file, ... }:

{
  systemd.services."game-file-uploader" = {
    after = ["network-online.target"];
    enable = true;
    serviceConfig = {
      Type = "simple";
      User = "media";
      ExecStart = "${simple-go-uploader-file}/bin/simple-go-uploader-file --rootFolder /files/media/jogos";
    };
  };
}
