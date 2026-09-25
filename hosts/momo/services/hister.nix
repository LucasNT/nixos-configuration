{
  config,
  lib,
  pkgs,
  ...
}:

{
  services.hister = {
    enable = true;
    dataDir = "/files/application/hister";
    environmentFile = /home/hister.env;
    settings = {
      app = {
        public = false;
      };
      server = {
        address = "127.0.0.1:4433";
        base_url = "https://search.geladeira.moe";
        oauth = {
          oidc = {
            client_id = "k4R.wUJm1ydo6hoGk5E7p7NJxAED7YoQ~_Ur4y~oypqDq.QV_dIXL77rh55AUhTlYeyDdCt6";
            configuration_url = "https://login.geladeira.moe/.well-known/openid-configuration";
          };
        };
      };
    };
  };

  fileSystems."/files/application/hister" = {
    device = "/dev/disk/by-uuid/b0f49523-ab2d-4c9a-9364-831463616ebe";
    fsType = "btrfs";
    options = [ "subvol=@applications/@Hister" ];
  };
}
