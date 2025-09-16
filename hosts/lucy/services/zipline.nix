{ config, ... }: {
  sops.secrets.ziplineenv = {
    sopsFile = ../../../secrets/zipline.env;
    format = "dotenv";
  };

  services.zipline = {
    enable = true;
    environmentFiles = [ config.sops.secrets.ziplineenv.path ];
    database.createLocally = true;
    settings = {
      CORE_HOSTNAME = "127.0.0.1";
      CORE_PORT = 3333;
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

  services.nginx.upstreams.zipline = {
    servers = {
      "127.0.0.1:${builtins.toString config.services.zipline.settings.CORE_PORT}" = {};
    };
    extraConfig = ''
    zone zipline 64K;
    '';
  };

  services.nginx.virtualHosts."i.ixhby.dev" = {
    onlySSL = true;
    sslCertificate = "/var/lib/acme/ixhby.dev/cert.pem";
    sslCertificateKey = "/var/lib/acme/ixhby.dev/key.pem";

    locations."/" = {
      proxyPass = "http://zipline";
    };
  };
}
