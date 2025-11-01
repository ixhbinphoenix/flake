{ config, lib, ...}: {
  options.stages.server.services.immich = {
    enable = lib.mkEnableOption "";
    internalDomain = lib.mkEnableOption "";
  };

  config = let
    cfg = config.stages.server.services.immich;
  in lib.mkIf cfg.enable {
    services.immich = {
      enable = true;

      port = 2283;
      host = "0.0.0.0";
      openFirewall = false;

      settings = {
        server = {
          externalDomain = "https://im.ixhby.dev";
        };
        passwordLogin = {
          enabled = true;
        };
      };

      redis = {
        enable = true;
      };

      database = {
        enable = true;
        createDB = true;

        enableVectors = false;
        enableVectorChord = true;
      };

      machine-learning = {
        enable = true;
      };
    };
    services.nginx.upstreams.immich = {
      servers = {
        "127.0.0.1:${builtins.toString config.services.immich.port}" = {};
      };
      extraConfig = ''
      zone immich 64K;
      '';
    };

    services.nginx.virtualHosts."im.ixhby.dev" = {
      serverAliases = (if cfg.internalDomain then [ "immich.internal.ixhby.dev" ] else []);
      onlySSL = true;
      sslCertificate = "/var/lib/acme/ixhby.dev/cert.pem";
      sslCertificateKey = "/var/lib/acme/ixhby.dev/key.pem";

      locations."/" = {
        proxyPass = "http://immich";

        extraConfig = ''
        client_max_body_size 0;
        '';
      };
    };
  };
}
