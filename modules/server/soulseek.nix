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
    services.nginx.upstreams.slskd = {
      servers = {
        "127.0.0.1:${builtins.toString config.services.slskd.settings.web.port}" = {};
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
  }]);
}
