{ config, pkgs, lib, inputs, ... }: {
  systemd.tmpfiles.settings.navidromeDirs = {
    "/var/lib/navidrome-music"."d" = {
      mode = "777";
      user = config.services.navidrome.user;
      group = config.services.navidrome.group;
    };
  };

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
}
