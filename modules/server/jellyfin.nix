{ config, lib, ... }: {
  options.stages.server.services.jellyfin = {
    enable = lib.mkEnableOption "Jellyfin";
  };

  config = let
    cfg = config.stages.server.services.jellyfin;
  in lib.mkIf cfg.enable (lib.mkMerge [{

    systemd.tmpfiles.settings.navidromeDirs = {
      "/var/lib/media/movies"."d" = {
        mode = lib.mkForce "777";
      };
      "/var/lib/media/shows"."d" = {
        mode = lib.mkForce "777";
      };
    };

    services.jellyfin = {
      enable = true;
    };

    services.nginx.upstreams.jellyfin = {
      servers = {
        "127.0.0.1:8096" = {};
      };
      extraConfig = ''
      zone jellyfin 64K;
      '';
    };

    services.nginx.virtualHosts."play.faggirl.gay" = {
      onlySSL = true;
      sslCertificate = "/var/lib/acme/faggirl.gay/cert.pem";
      sslCertificateKey = "/var/lib/acme/faggirl.gay/key.pem";

      locations."/" = {
        proxyPass = "http://jellyfin";

        extraConfig = ''
        proxy_buffering off;
        '';
      };

      locations."/socket" = {
        proxyPass = "http://jellyfin";
        proxyWebsockets = true;
      };
    };
  }]);
}
