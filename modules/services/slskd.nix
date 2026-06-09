{}: {
  flake.modules.nixos.slskd = { config, ... }: {
    users.users."${config.services.slskd.group}".extraGroups = [ "media" ];

    sops.secrets.slskd = {
      sopsFile = ../../secrets/slskd.env;
      format = "dotenv";
    };

    services.slskd = {
      enable = true;
      openFirewall = true;
      domain = null; # disables the integrated nginx module cuz we wanna use our own
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

    server.services.nginx.vhosts."slskd.ixhby.dev" = {
      service_name = "slskd";
      protocol = "http";
      servers = [ "127.0.0.1:${toString config.services.slskd.settings.web.port}" ];
      cert_path = "ixhby.dev";
    };

    services.nginx.virtualHosts."slskd.ixhby.dev".locations."/".proxyWebsockets = true;
  };
}
