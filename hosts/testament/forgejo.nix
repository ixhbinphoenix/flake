{ config, pkgs, lib, inputs, ... }:
{
  users.users.git = {
    home = config.services.forgejo.stateDir;
    useDefaultShell = true;
    group = "git";
    isSystemUser = true;
  };

  services.forgejo = {
    enable = true;
    package = pkgs.forgejo;
    
    user = "git";
    group = "git";

    lfs.enable = true;

    secrets = {
      security.SECRET_KEY = "";
      security.INTERNAL_TOKEN = "";
      mailer.PASSWD = "";
      oauth2.JWT_SECRET = "";
      LFS_JWT_SECRET = "";
    };

    settings = {
      APP_NAME = "ixhby.dev git";
      RUN_MODE = "prod";
      server = {
        DOMAIN = "git.ixhby.dev";
        ROOT_URL = "https://git.ixhby.dev/";
        HTTP_PORT = 3000;

        LFS_START_SERVER = true;

        OFFLINE_MODE = false;

        # TODOOO: Figure out SSH for native forgejo again
        DISABLE_SSH = false;
        SSH_USER = "git";
        SSH_DOMAIN = "git.ixhby.dev";
      };

      database = {
        HOST = "127.0.0.1:5432";
        NAME = "gitea";
        USER = "gitea";
        PASSWD = "gitea";
        SSL_MODE = "disable";
        LOG_SQL = false;
      };

      mailer = {
        ENABLED = true;
        SMTP_ADDR = "mail.mailtwo24.de";
        SMTP_PORT = 587;
        FROM = "git@ixhby.dev";
        USER = "git@ixhby.dev";
        PASSWD = "TODO: Nix secrets";
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
        NO_REPLY_ADDRESS = noreply.localhost;
      };

      repository = {
        ENABLE_PUSH_CREATE_USER = true;
        ENABLE_PUSH_CREATE_ORG = true;
        PREFERRED_LICENSES = "AGPL-3.0-only, AGPL-3.0-or-later, GPL-3.0-only, GPL-3.0-or-later, MIT";
        DEFAULT_BRANCH = "root";

        pull-request = {
          DEFAULT_MERGE_STYLE = "merge";
        };
        signing = {
          DEFAULT_TRUST_MODEL = "committer";
        };
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
        TOKEN = "TODO: Nix secrets";
      };

      # TODOO: ui.THEMES
      # TODOO: ui.CUSTOM_EMOJIS
    };
  };

  services.postgresql = {
    enable = true;

    ensureDatabases = [
      "gitea"
    ];

    ensureUsers.gitea = {
      ensureDBOwnership = true;
    };
  };
}
