{ config, ...}: {

  sops.secrets.pds = {
    sopsFile = ../../secrets/testament/pds.env;
    format = "dotenv";
  };

  services.pds = {
    enable = true;
    pdsadmin.enable = true;

    environmentFiles = [ config.sops.secrets.pds.path ];
    settings = {
      PDS_HOSTNAME = "pds.ixhby.dev";
      PDS_PORT = 6145;
      PDF_EMAIL_FROM_ADDRESS = "contact+bsky@ixhby.dev";
    };
  };
}
