{ config, pkgs, lib, inputs, ... }: let
  cfg = config.services.forgejo;
  users = config.users.users;
in {

  users.users.git = {
    home = config.services.forgejo.stateDir;
    useDefaultShell = true;
    group = "git";
    isSystemUser = true;
  };

  users.groups.git = {};

  sops.secrets = let
    gitSecret = {
      owner = users.git.name;
      group = users.git.group;
    };
  in {
    "forgejo/mailer/PASSWD" = gitSecret;
    "forgejo/LFS_JWT_SECRET" = gitSecret;
    "forgejo/security/INTERNAL_TOKEN" = gitSecret;
    "forgejo/metrics/TOKEN" = gitSecret;
    "forgejo/oauth2/JWT_SECRET" = gitSecret;
    "forgejo/database_password" = gitSecret;
  };

  services.postgresql = {
    authentication = pkgs.lib.mkOverride 10 ''
      #type database DBuser auth-method
      local all      all    trust
      #type database DBuser origin       auth-method
      host  all      all    127.0.0.1/32 trust
      host  all      all    ::1/128      trust
    '';
  };

  services.forgejo = {
    enable = true;
    package = pkgs.forgejo;
    
    user = "git";
    group = "git";

    lfs.enable = true;

    # Warning: This only works on nixos-unstable currently
    secrets = let
      secret = path: config.sops.secrets."forgejo/${path}".path;
    in {
      DEFAULT.LFS_JWT_SECRET = secret "LFS_JWT_SECRET";
      metrics.TOKEN = secret "metrics/TOKEN";
      security.INTERNAL_TOKEN = lib.mkForce (secret "security/INTERNAL_TOKEN");
      oauth2.JWT_SECRET = lib.mkForce (secret "oauth2/JWT_SECRET");
      mailer.PASSWD = secret "mailer/PASSWD";
    };

    database = {
      type = "postgres";
      createDatabase = true;
      user = "git";
      passwordFile = config.sops.secrets."forgejo/database_password".path;
      name = "git";
    };

    settings = {
      DEFAULT = {
        APP_NAME = "ixhby.dev\ git";
        RUN_MODE = "prod";
      };
      server = {
        DOMAIN = "git.ixhby.dev";
        ROOT_URL = "https://git.ixhby.dev/";
        HTTP_PORT = 3000;

        LFS_START_SERVER = true;

        OFFLINE_MODE = false;

        DISABLE_SSH = false;
        SSH_USER = "git";
        SSH_DOMAIN = "git.ixhby.dev";
      };

      mailer = {
        ENABLED = true;
        SMTP_ADDR = "mail.mailtwo24.de";
        SMTP_PORT = 587;
        FROM = "git@ixhby.dev";
        USER = "git@ixhby.dev";
      };

      service = {
        REGISTER_EMAIL_CONFIRM = true;
        ENABLE_NOTIFY_MAIL = true;
        DISABLE_REGISTRATION = false;
        ALLOW_ONLY_EXTERNAL_REGISTRATION = false;
        ENABLE_CAPTCHA = true;
        REQUIRE_SIGNIN_VIEW = false;
        DEFAULT_KEEP_EMAIL_PRIVATE = false;
        DEFAULT_ALLOW_CREATE_ORGANIZATION = true;
        DEFAULT_ENABLE_TIMETRACKING = true;
        NO_REPLY_ADDRESS = "noreply.localhost";
      };

      repository = {
        ENABLE_PUSH_CREATE_USER = true;
        ENABLE_PUSH_CREATE_ORG = true;
        PREFERRED_LICENSES = "AGPL-3.0-only, AGPL-3.0-or-later, GPL-3.0-only, GPL-3.0-or-later, MIT";
        DEFAULT_BRANCH = "root";
      };

      "repository.pull-request" = {
          DEFAULT_MERGE_STYLE = "merge";
      };

      "repository.signing" = {
          DEFAULT_TRUST_MODEL = "committer";
      };

      security = {
        INSTALL_LOCK = true;
        PASSWORD_HASH_ALGO = "pbkdf2";
        LOGIN_REMEMBER_DAYS = 30;
        REVERSE_PROXY_LIMIT = 1;
        REVERSE_PROXY_TRUSTED_PROXIES = "*";
      };

      actions = {
        enabled = true;
        DEFAULT_ACTIONS_URL = "https://code.forgejo.org";
      };

      metrics = {
        ENABLED = true;
        ENABLE_ISSUE_BY_LABEL = true;
        ENABLE_ISSUE_BY_REPOSITORY = true;
      };

      # TODOO: ui.THEMES
      # TODOO: ui.CUSTOM_EMOJIS
    };
  };
}
