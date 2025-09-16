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

  services.nginx.upstreams.navidrome = {
    servers = {
      "127.0.0.1:4533" = {};
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
}
