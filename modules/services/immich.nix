{}: {
  flake.modules.nixos.immich = { config, ... }: {
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
      };

      machine-learning = {
        enable = true;
      };
    };

    server.services.nginx.vhosts."im.ixhby.dev" = {
      service_name = "immich";
      protocol = "http";
      servers = ["127.0.0.1:${toString config.services.immich.port}"];
      cert_path = "ixhby.dev";
      extraConfig = ''
      client_max_body_size 0;
      '';
    };

    services.nginx.virtualHosts."im.ixhby.dev".serverAliases = ["immich.internal.ixhby.dev"];
  };
}
