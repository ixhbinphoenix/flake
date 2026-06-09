{}: {
  flake.modules.nixos.media = { lib, ... }: {
    systemd.tmpfiles.settings.navidromeDirs = {
      "/var/lib/media/movies"."d" = {
        mode = lib.mkForce "0774";
        user = "jellyfin";
        group = "media";
      };
      "/var/lib/media/shows"."d" = {
        mode = lib.mkForce "0774";
        user = "jellyfin";
        group = "media";
      };
      "/var/lib/navidrome-music"."d" = {
        mode = lib.mkForce "0772";
        group = lib.mkForce "media";
      };
    };

    users.groups.media = {
      gid = 1001;
    };
  };
}
