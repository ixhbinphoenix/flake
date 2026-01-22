{ config, lib, ... }: {
  options.stages.server.services.navidrome = {
    enable = lib.mkEnableOption "";
  };

  config = lib.mkIf config.stages.server.services.navidrome.enable {
    systemd.tmpfiles.settings.navidromeDirs = {
      "/var/lib/navidrome-music"."d" = {
        mode = lib.mkForce "0772";
        group = lib.mkForce "media";
      };
    };

    users.users."${config.services.navidrome.user}".extraGroups = [ "media" ];

    services.navidrome = {
      enable = true;
      settings = {
        BaseUrl = "https://navi.ixhby.dev";
        MusicFolder = "/var/lib/navidrome-music";
        EnableSharing = true;
        Prometheus = {
          enable = true;
        };
        SubsonicArtistParticipations = true;
      };
    };

    services.nginx.upstreams.navidrome = {
      servers = {
        "127.0.0.1:${builtins.toString config.services.navidrome.settings.Port}" = {};
      };
      extraConfig = ''
      zone navidrome 64K;
      '';
    };

    services.nginx.virtualHosts."navi.ixhby.dev" = {
      onlySSL = true;
      sslCertificate = "/var/lib/acme/ixhby.dev/cert.pem";
      sslCertificateKey = "/var/lib/acme/ixhby.dev/key.pem";

      locations."/" = {
        proxyPass = "http://navidrome";
      };
    };
  };
}
