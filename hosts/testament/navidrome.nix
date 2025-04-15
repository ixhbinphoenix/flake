{ config, pkgs, lib, inputs, ... }: {
  systemd.tmpfiles.settings.navidromeDirs = {
    "/var/lib/navidrome-music"."d" = {
      mode = lib.mkForce "777";
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
