{pkgs, ...} :
{
  services.garage = {
    enable = true;
    environmentFile = /home/garage.env;
    package = pkgs.garage_2;
    logLevel = "debug";
    settings = {
      data_dir = "/files/application/garage/data";
      metadata_dir = "/files/application/garage/";
      db_engine = "sqlite";
      replication_factor = 1;
      rpc_bind_addr = "127.0.0.1:3901";
      rpc_public_addr = "127.0.0.1:3901";
      rpc_secret = "$RPC_SECRET";
      s3_api = {
        s3_region = "momo";
        api_bind_addr = "0.0.0.0:3900";
        root_domain = ".s3.momo.geladeira.moe";
      };
      admin = {
        api_bind_addr = "127.0.0.1:3903";
        admin_token = "$ADMIN_TOKEN";
        metrics_token = "$METRICS_TOKEN";
      };
    };
  };
}
