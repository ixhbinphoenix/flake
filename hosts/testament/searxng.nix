{ config, pkgs, lib, inputs, ... }: let
  users = config.users.users;
in {
  sops.secrets.searx = {
    sopsFile = ../../secrets/testament/searx.env;
    format = "dotenv";
    owner = users.searx.name;
    group = users.searx.group;
  };

  services.searx = {
    enable = true;
    package = pkgs.searxng;

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
