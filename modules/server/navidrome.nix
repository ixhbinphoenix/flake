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

    stages.server.services.nginx.vhosts."navi.ixhby.dev" = {
      service_name = "navidrome";
      protocol = "http";
      servers = [ "127.0.0.1:${toString config.services.navidrome.settings.Port}" ];
      cert_path = "ixhby.dev";
    };

  };
}
