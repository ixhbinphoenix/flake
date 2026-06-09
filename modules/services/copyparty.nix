{ inputs, ... }: {

  flake.modules.nixos.copyparty = { config, ... }: {

    users.users.copyparty.extraGroups = [ "media" ];

    services.copyparty = {
      enable = true;
      user = "copyparty";
      group = "copyparty";

      settings = {
        i = "unix:777:copyparty:/dev/shm/copyparty.sock";
        p = [ 9723 ];

        xff-hdr = "X-Real-IP";
        rproxy = 1;

        og = true;
        dedup = true;
        e2dsa = true;
        e2ts = true;
        hardlink-only = true;
        re-maxage = 60;
        no-robots = true;
      };

      accounts = {
        ixhby.passwordFile = config.sops.secrets."copyparty/passwords/ixhby".path;
      };

      groups = {
        admin = [ "ixhby" ];
      };

      volumes = let
        vols = [
          { vpath = "/shows"; fpath = "/var/lib/media/shows"; }
          { vpath = "/movies"; fpath = "/var/lib/media/movies"; }
          { vpath = "/music"; fpath = "/var/lib/navidrome-music"; }
        ];

        defvol = {
          access = {
            A = [ "@admin" ];
          };
          flags = {
            gid = 1001;
            chmod_f = 774;
          };
        };
      in builtins.listToAttrs (map (x: {
        name = x.vpath;
        value = {
          path = x.fpath;
        } // defvol;
      }) vols);

      openFilesLimit = 8192;
    };

    sops.secrets = let
      copypartySecret = {
        owner = "copyparty";
        group = "copyparty";
      };
    in {
      "copyparty/passwords/ixhby" = copypartySecret;
    };

    server.services.nginx.vhosts."media.faggirl.gay" = {
      service_name = "copyparty";
      protocol = "http";
      servers = [ "unix:/dev/shm/copyparty.sock" ];
      cert_path = "faggirl.gay";
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

    nixpkgs.overlays = [ inputs.copyparty.overlays.default ];

  };
}
