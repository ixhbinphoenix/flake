{ config, pkgs, lib, inputs, ... }: {
  # TODO: Remove this import, as well as the flake input, as soon as nixpkgs#370878 gets merged
  imports = [
    "${inputs.pr-370878-zipline}/nixos/modules/services/web-apps/zipline.nix"
  ];

  services.zipline = {
    enable = true;
    environmentFiles = [ config.sops.secrets.ziplineenv.path ];
    settings = {
      CORE_RETURN_HTTPS = "true";
      CORE_HOST = "127.0.0.1";
      CORE_PORT = "3333";
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
    database.createLocally = true;
  };

  sops.secrets.ziplineenv = {
    sopsFile = ../../secrets/testament/zipline.env;
    format = "dotenv";
  };
}
