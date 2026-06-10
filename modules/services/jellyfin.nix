{
  flake.modules.nixos.jellyfin = {
    users.users."jellyfin".extraGroups = [ "media" ];

    services.jellyfin = {
      enable = true;
    };

    server.services.nginx.vhosts."play.faggirl.gay" = {
      service_name = "jellyfin";
      protocol = "http";
      servers = [ "127.0.0.1:8096" ];
      cert_path = "faggirl.gay";
      extraConfig = ''
      proxy_buffering off;
      '';
    };

    services.nginx.virtualHosts."play.faggirl.gay".locations."/".proxyWebsockets = true;
  };
}
