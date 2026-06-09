{}: {
  flake.modules.nixos.navidrome = { config, ... }: {
    users.users."navidrome".extraGroups = [ "media" ];

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

    server.services.nginx.vhosts."navi.ixhby.dev" = {
      service_name = "navidrome";
      protocol = "http";
      servers = ["127.0.0.1:${toString config.services.navidrome.settings.Port}"];
      cert_path = "ixhby.dev";
    };
  };
}
