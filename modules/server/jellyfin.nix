{ config, lib, ... }: {
  options.stages.server.services.jellyfin = {
    enable = lib.mkEnableOption "Jellyfin";
  };

  config = let
    cfg = config.stages.server.services.jellyfin;
  in lib.mkIf cfg.enable (lib.mkMerge [{

    systemd.tmpfiles.settings.navidromeDirs = {
      "/var/lib/media/movies"."d" = {
        mode = lib.mkForce "0774";
        user = config.services.jellyfin.user;
        group = "media";
      };
      "/var/lib/media/shows"."d" = {
        mode = lib.mkForce "0774";
        user = config.services.jellyfin.user;
        group = "media";
      };
    };

    users.users."${config.services.jellyfin.group}".extraGroups = [ "media" ];

    services.jellyfin = {
      enable = true;
    };

    stages.server.services.nginx.vhosts."play.faggirl.gay" = {
      service_name = "jellyfin";
      protocol = "http";
      servers = [ "127.0.0.1:8096" ];
      cert_path = "faggirl.gay";
      extraConfig = ''
      proxy_buffering off;
      '';
    };

    services.nginx.virtualHosts."play.faggirl.gay".locations."/".proxyWebsockets = true;

  }]);
}
