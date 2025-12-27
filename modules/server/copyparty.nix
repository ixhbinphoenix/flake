{ config, lib, inputs, ... }: {
  options.stages.server.services.copyparty = {
    enable = lib.mkEnableOption "copyparty file server";
  };

  config = let
    cfg = config.stages.server.services.copyparty;
  in lib.mkIf (cfg.enable) {

    sops.secrets = let
      copypartySecret = {
        owner = config.services.copyparty.user;
        group = config.services.copyparty.group;
      };
    in {
      "copyparty/passwords/ixhby" = copypartySecret;
      "copyparty/passwords/katie" = copypartySecret;
    };

    services.copyparty = {
      enable = true;
      user = "copyparty";
      group = "copyparty";

      settings = {
        i = "unix:777:copyparty:/dev/shm/copyparty.sock";
        p = [ 9723 ];

        xff-hdr = "X-Real-IP";
        rproxy = 1;

        og = true; # opengraph, media embeds
        dedup = true; # file deduplication
        e2dsa = true; # file indexing
        e2ts = true; # check newly discovered files for media tags
        hardlink-only = true; # use hardlink-based dedup instead of symlink
        re-maxage = 60; # rescan all volumes every 60 seconds
        no-robots = true; # hide from google
      };

      accounts = {
        ixhby.passwordFile = config.sops.secrets."copyparty/passwords/ixhby".path;
        katie.passwordFile = config.sops.secrets."copyparty/passwords/katie".path;
      };

      groups = {
        admin = [ "ixhby" "katie" ];
      };

      volumes = {
        "/shows" = {
          path = "/var/lib/media/shows";
          access = {
            rw = [ "ixhby" "katie" ];
          };
        };
        "/movies" = {
          path = "/var/lib/media/movies";
          access = {
            rw = [ "ixhby" "katie" ];
          };
        };
        "/music" = {
          path = "/var/lib/navidrome-music";
          access = {
            rw = [ "ixhby" "katie" ];
          };
        };
      };

      openFilesLimit = 8192;
    };

    services.nginx.upstreams.copyparty = {
      servers = {
        "unix:/dev/shm/copyparty.sock" = {};
      };
    };

    services.nginx.virtualHosts."media.faggirl.gay" = {
      onlySSL = true;
      sslCertificate = "/var/lib/acme/faggirl.gay/cert.pem";
      sslCertificateKey = "/var/lib/acme/faggirl.gay/key.pem";

      locations."/" = {
        proxyPass = "http://copyparty";
        extraConfig = ''
        proxy_http_version 1.1;
        client_max_body_size 0;
        proxy_buffering off;
        proxy_request_buffering off;

        proxy_buffers 32 8k;
        proxy_buffer_size 16k;
        proxy_busy_buffers_size 24k;
        '';
      };
    };

    nixpkgs.overlays = [ inputs.copyparty.overlays.default ];
  };
}
