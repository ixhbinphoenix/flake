{ config, lib, ...}: {
  options.stages.server.services.slskd = {
    enable = lib.mkEnableOption "";
  };

  config = let
    cfg = config.stages.server.services.slskd;
  in lib.mkIf cfg.enable (lib.mkMerge [
  {
    sops.secrets.slskd = {
      sopsFile = ../../secrets/slskd.env;
      format = "dotenv";
    };

    users.users."${config.services.slskd.group}".extraGroups = [ "media" ];

    services.slskd = {
      enable = true;
      openFirewall = true;
      domain = null; # nulled so we don't use the NixOS module nginx integration
      environmentFile = config.sops.secrets.slskd.path;
      settings = {
        shares = {
          directories = [
            "/var/lib/navidrome-music"
            "!/var/lib/navidrome-music/spezi-ell"
            "!/var/lib/navidrome-music/soundboard"
          ];
          filters = [
            "rsync.sh$"
            "TheMissile\.wav(.asd)?$"
            "BCSRingtone.mp3"
          ];
        };
      };
    };

    stages.server.services.nginx.vhosts."slskd.ixhby.dev" = {
      service_name = "slskd";
      protocol = "http";
      servers = [ "127.0.0.1:${toString config.services.slskd.settings.web.port}" ];
      cert_path = "ixhby.dev";
    };

    services.nginx.virtualHosts."slskd.ixhby.dev".locations."/".proxyWebsockets = true;
  }]);
}
