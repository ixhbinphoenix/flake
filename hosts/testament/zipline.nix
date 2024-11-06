{ config, pkgs, lib, inputs, ... }: let
  basePath = "/var/lib/zipline";
  uploads = basePath + "/uploads";
  public = basePath + "/public";
in {

  systemd.tmpfiles.rules = [
    "d '${basePath}' 0700 root root - -"
    "z '${basePath}' 0700 root root - -"
    "d '${uploads}' 0700 root root - -"
    "z '${uploads}' 0700 root root - -"
    "d '${public}' 0700 root root - -"
    "z '${public}' 0700 root root - -"
    "d '/var/lib/zipline-postgres' 0700 postgres postgres - -"
    "z '/var/lib/zipline-postgres' 0700 postgres postgres - -"
  ];

  sops.secrets."zipline/db_password" = {
    owner = config.users.users.postgres.name;
    group = config.users.users.postgres.group;
  };

  #systemd.services."postgresql-zipline-setup" = {
  #  serviceConfig = {
  #    Type = "oneshot";
  #    User = "postgres";
  #    RuntimeDirectory = "postgresql-zipline-setup";
  #    RuntimeDirectoryMode = "700";
  #  };
  #  requiredBy = ["zipline.service"];
  #  after = ["postgresql.service"];
  #  path = with pkgs; [ postgresql replace-secret ];
  #  script = let
  #    initsql = pkgs.writeTextFile {
  #      name = "init.sql";
  #      text = ''
  #        ALTER USER zipline WITH ENCRYPTED PASSWORD '@ZIPLINE_DB_PASSWORD@';
  #      '';
  #    };
  #  in ''
  #    set -o errexit -o pipefail -o nounset -o errtrace
  #    shopt -s inherit_errexit
  #    install --mode 600 ${initsql} ''$RUNTIME_DIRECTORY/init.sql
  #    ${pkgs.replace-secret}/bin/replace-secret @ZIPLINE_DB_PASSWORD@ ${config.sops.secrets."zipline/db_password".path} ''$RUNTIME_DIRECTORY/init.sql
  #    psql zipline --file "''$RUNTIME_DIRECTORY/init.sql"
  #  '';
  #};

  sops.secrets.ziplineenv = {
    sopsFile = ../../secrets/testament/zipline.env;
    format = "dotenv";
  };

  # TODO: Make a network for this

  virtualisation.quadlet.containers.zipline-postgres = {
    containerConfig = {
      image = "docker.io/postgres:15";
      name = "zipline-postgres";
      autoUpdate = "registry";
      
      podmanArgs = [
        "-p 5433:5432"
      ];

      volumes = [
        "${config.sops.secrets."zipline/db_password".path}:/db_password"
        "/var/lib/zipline-postgres:/var/lib/postgresql/data"
      ];

      environments = {
        POSTGRES_USER="postgres";
        POSTGRES_DATABASE="postgres";
        POSTGRES_PASSWORD_FILE="/db_password";
      };
    };
  };

  virtualisation.quadlet.containers.zipline = {
    containerConfig = {
      image = "ghcr.io/diced/zipline";
      name = "zipline";
      autoUpdate = "registry";

      networks = [ "host" ];

      volumes = [
        "${uploads}:/zipline/uploads"
        "${public}:/zipline/public"
      ];

      environmentFiles = [
        config.sops.secrets.ziplineenv.path
      ];

      environments = {
        CORE_RETURN_HTTPS = true;
        CORE_HOST = "127.0.0.1";
        CORE_PORT = 3333;
        CORE_LOGGER = true;
        EXIF_REMOVE_GPS = true;
        FEATURES_ROBOTS_TXT = true;
        MFA_TOTP_ENABLED = true;
        MFA_TOTP_ISSUER = "Ixhby Zipline";
        RATELIMIT_ADMIN = 0;
        UPLOADER_DEFAULT_FORMAT = "RANDOM";
        UPLOADER_ROUTE = "/u";
        UPLOADER_LENGTH = 8;
        UPLOADER_ASSUME_MIMETYPES = true;
        URLS_ROUTE = "/s";
        WEBSITE_TITLE = "Ixhby's Zipline";
        WEBSITE_SHOW_FILES_PER_USER = true;
        WEBSITE_SHOW_VERSION = true;
      };
    };
  };
}
