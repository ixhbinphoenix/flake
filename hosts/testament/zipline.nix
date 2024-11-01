{ config, pkgs, lib, inputs, ... }: let
  basePath = "/var/lib/zipline";
  uploads = basePath + "/uploads";
  public = basePath + "/public";
in {

  users.users.zipline = {
    isSystemUser = true;
    useDefaultShell = true;
    group = "zipline";
    uid = 50000;
  };

  users.groups.zipline = {
    gid = 50000;
  };

  systemd.tmpfiles.rules = let
    user = config.users.users.zipline.name;
    group = config.users.users.zipline.group;
  in [
    "d '${basePath}' 0700 ${user} ${group} - -"
    "z '${basePath}' 0700 ${user} ${group} - -"
    "d '${uploads}' 0700 ${user} ${group} - -"
    "z '${uploads}' 0700 ${user} ${group} - -"
    "d '${public}' 0700 ${user} ${group} - -"
    "z '${public}' 0700 ${user} ${group} - -"
  ];

  services.postgresql = {
    enable = true;

    ensureDatabases = [
      "zipline"
    ];

    ensureUsers = [
      {
        name = "zipline";
        ensureDBOwnership = true;
      }
    ];
  };

  sops.secrets."zipline/db_password" = {
    owner = config.users.users.postgres.name;
    group = config.users.users.postgres.group;
  };

  systemd.services."postgresql-zipline-setup" = {
    serviceConfig = {
      Type = "oneshot";
      User = "postgres";
      RuntimeDirectory = "postgresql-zipline-setup";
      RuntimeDirectoryMode = "700";
    };
    requiredBy = ["zipline.service"];
    after = ["postgresql.service"];
    path = with pkgs; [ postgresql replace-secret ];
    script = let
      initsql = pkgs.writeTextFile {
        name = "init.sql";
        text = ''
          ALTER USER zipline WITH ENCRYPTED PASSWORD '@ZIPLINE_DB_PASSWORD@';
        '';
      };
    in ''
      set -o errexit -o pipefail -o nounset -o errtrace
      shopt -s inherit_errexit
      install --mode 600 ${initsql} ''$RUNTIME_DIRECTORY/init.sql
      ${pkgs.replace-secret}/bin/replace-secret @ZIPLINE_DB_PASSWORD@ ${config.sops.secrets."zipline/db_password".path} ''$RUNTIME_DIRECTORY/init.sql
      psql zipline --file "''$RUNTIME_DIRECTORY/init.sql"
    '';
  };

  virtualisation.quadlet = let 
    user = config.users.users.zipline;
    uid = user.uid;
    gid = config.users.groups.${user.group}.gid;
  in {
    containers = {
      zipline = {
        containerConfig = {
          image = "ghcr.io/diced/zipline";
          name = "zipline";
          autoUpdate = "registry";

          user = user.name;
          group = user.group;

          userns = "keep-id:uid=${builtins.toString uid},gid=${builtins.toString gid}";

          networks = [ "host" ];

          mounts = [
            "${uploads}:/zipline/uploads"
            "${public}:/zipline/public"
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
    };
  };
}
