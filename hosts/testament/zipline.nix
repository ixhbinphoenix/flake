{ config, lib, ... }: {

  services.zipline = {
    enable = true;
    environmentFiles = [ config.sops.secrets.ziplineenv.path ];
    database.createLocally = false;
    settings = {
      CORE_HOSTNAME = "127.0.0.1";
      CORE_PORT = 3333;
      DATABASE_URL = "postgresql://ziplinev4@localhost/ziplinev4?host=/run/postgresql";
      EXIF_REMOVE_GPS = "true";
      FEATURES_ROBOTS_TXT = "true";
      MFA_TOTP_ISSUER = "Ixhby's Zipline";
      MFA_TOTP_ENABLED = "true";
      RATELIMIT_ADMIN = "0";
      UPLOADER_DEFAULT_FORMAT = "RANDOM";
      UPLOADER_ROUTE = "/u";
      UPLOADER_LENGTH = "8";
      UPLOADER_ASSUME_MIMETYPES = "true";
      URLS_ROUTE = "/s";
      WEBSITE_TITLE = "Ixhby's Zipline";
      WEBSITE_SHOW_FILES_PER_USER = "true";
      WEBSITE_SHOW_VERSION = "true";
    };
  };

  services.postgresql = {
    ensureUsers = lib.singleton {
      name = "ziplinev4";
      ensureDBOwnership = true;
    };
    ensureDatabases = [ "ziplinev4" ];
  };

  sops.secrets.ziplineenv = {
    sopsFile = ../../secrets/testament/zipline.env;
    format = "dotenv";
  };
}
