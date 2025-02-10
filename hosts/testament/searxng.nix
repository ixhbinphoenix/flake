{ config, pkgs, lib, inputs, ... }: let
  users = config.users.users;

  # TODO: https://github.com/NixOS/nixpkgs/issues/380351
  override = (pkgs.searxng.override {
    python3 = pkgs.python3.override { 
      packageOverrides = pyFinal: pyPrev: {
        httpx = pyPrev.httpx.overridePythonAttrs (o: rec {
          version = "0.27.2";
          src = pkgs.fetchFromGitHub {
            owner = "encode";
            repo = o.pname;
            tag = version;
            hash = "sha256-N0ztVA/KMui9kKIovmOfNTwwrdvSimmNkSvvC+3gpck=";
          };
        });
        starlette = pyPrev.starlette.overridePythonAttrs (o: rec {
          version = "0.41.2";
          src = pkgs.fetchFromGitHub {
            owner = "encode";
            repo = o.pname;
            tag = version;
            hash = "sha256-ZNB4OxzJHlsOie3URbUnZywJbqOZIvzxS/aq7YImdQ0=";
          };
        });
        httpx-socks = pyPrev.httpx-socks.overridePythonAttrs (o: rec {
          version = "0.9.2";
          src = pkgs.fetchFromGitHub {
            owner = "romis2012";
            repo = o.pname;
            tag = "v${version}";
            hash = "sha256-PUiciSuDCO4r49st6ye5xPLCyvYMKfZY+yHAkp5j3ZI=";
          };
        });
      };
    };
  });
in {
  sops.secrets.searx = {
    sopsFile = ../../secrets/testament/searx.env;
    format = "dotenv";
    owner = users.searx.name;
    group = users.searx.group;
  };

  services.searx = {
    enable = true;
    package = override;

    redisCreateLocally = true;

    environmentFile = config.sops.secrets.searx.path;

    settings = {
      general = {
        debug = false;
        instance_name = "searchXhby";
        privacypolicy_url = false;
        donation_url = false;
        contact_url = "mailto:contact@ixhby.dev";
        enable_metrics = true;
      };
      search = {
        safe_search = 0;
        autocomplete = "";
        default_lang = "auto";
        ban_time_on_fail = 5;
        max_ban_time_on_fail = 120;
      };
      server = {
        port = 3030;
        bind_address = "127.0.0.1";
        base_url = "https://search.ixhby.dev/";
        limiter = true;
        public_instance = true;

        secret_key = "SetInEnvironmentFile";
        image_proxy = true;
        http_protocol_version = "1.0";
        method = "POST";
      };
      ui = {
        hotkeys = "vim";
      };
      outgoing = {
        request_timeout = 3.0;
        useragent_suffix = "contact@ixhby.dev";
        enable_http2 = true;
      };
    };

    limiterSettings = {
      real_ip = {
        x_for = 1;
        ipv4_prefix = 32;
        ipv6_prefix = 48;
      };
      botdetection = {
        ip_limit = {
          filter_link_local = false;
          link_token = false;
        };
        ip_lists = {
          pass_ip = [
            "192.168.0.0/16"
            "fe80::/10"
          ];

          pass_searxng_org = true;
        };
      };
    };
  };
}
