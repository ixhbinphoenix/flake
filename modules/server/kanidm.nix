{ config, lib, pkgs, ... }: {
  options.stages.server.services.kanidm = {
    enable = lib.mkEnableOption "kanidm auth provider";

    domain = lib.mkOption {
      type = lib.types.nonEmptyStr;
      example = "auth.ixhby.dev";
      description = "Domain (with subdomain) kanidm should be running on";
    };

    bind = lib.mkOption {
      type = lib.types.nonEmptyStr;
      example = "0.0.0.0";
      default = "127.0.0.1";
      description = "IP adress to bind kanidm on";
    };
    port = lib.mkOption {
      type = lib.types.port;
      default = 7873;
      description = "IP adress to run kanidm on";
    };

    provision = {
      autoRemove = lib.mkEnableOption "Remove data that was removed from provisioning";
    };
  };

  config = let
    cfg = config.stages.server.services.kanidm;
    certs = config.security.acme.certs."${cfg.domain}";
  in lib.mkIf cfg.enable {
    services.kanidm = {
      package = pkgs.kanidmWithSecretProvisioning_1_8;

      enableServer = true;
      serverSettings = {
        domain = cfg.domain;
        origin = "https://${cfg.domain}";
        tls_chain = "${certs.directory}/fullchain.pem";
        tls_key = "${certs.directory}/key.pem";
        bindaddress = "${cfg.bind}:${builtins.toString cfg.port}";

        http_client_address_info = {
          x-forward-for = ["127.0.0.1"];
        };

        online_backup = {
          path = "/var/lib/kanidm_backups/";
          schedule = "00 03 * * *";
          versions = 2;
        };
      };

      enableClient = true;
      clientSettings = {
        uri = "https://${cfg.domain}";
      };

      provision = {
        enable = true;
        autoRemove = cfg.provision.autoRemove;
      };
    };

    systemd.services.kanidm.after = ["acme-auth.ixhby.dev.service"];

    security.acme.certs."auth.ixhby.dev" = {
      dnsProvider = "porkbun";
      webroot = lib.mkForce null;
      email = "contact+acme@ixhby.dev";
      environmentFile = config.sops.secrets.acme.path;
    };

    users.users.kanidm.extraGroups = [ "acme" ];

    services.nginx.upstreams.kanidm = {
      servers = {
        "127.0.0.1:${builtins.toString cfg.port}" = {};
      };
    };

    services.nginx.virtualHosts."auth.ixhby.dev" = {
      onlySSL = true;
      sslCertificate = "/var/lib/acme/auth.ixhby.dev/cert.pem";
      sslCertificateKey = "/var/lib/acme/auth.ixhby.dev/key.pem";

      locations."/" = {
        proxyPass = "https://kanidm";
        extraConfig = ''
        proxy_ssl_name auth.ixhby.dev;
        '';
      };
    };
  };
}
