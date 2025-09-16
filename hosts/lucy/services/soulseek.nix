{ config, ...}: {
  imports = [
    ./navidrome.nix
  ];

  sops.secrets.slskd = {
    sopsFile = ../../../secrets/slskd.env;
    format = "dotenv";
  };

  services.slskd = {
    enable = true;
    openFirewall = true;
    domain = null;
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

  services.nginx.upstreams.slskd = {
    servers = {
      "127.0.0.1:5030" = {};
    };
    extraConfig = ''
    zone slskd 64K;
    '';
  };

  services.nginx.virtualHosts."slskd.ixhby.dev" = {
    onlySSL = true;
    sslCertificate = "/var/lib/acme/ixhby.dev/cert.pem";
    sslCertificateKey = "/var/lib/acme/ixhby.dev/key.pem";
    
    locations."/" = {
      proxyPass = "http://slskd";
      proxyWebsockets = true;
    };
  };
}
