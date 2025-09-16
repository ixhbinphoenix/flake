{ config, pkgs, lib, inputs, ... }:
{
  users.users.ntfy-sh = {
    isSystemUser = true;
    useDefaultShell = true;
    group = "ntfy-sh";
    uid = 991;
  };

  users.groups.ntfy-sh = {
    gid = 987;
  };

  sops.secrets.ntfy = {
    sopsFile = ../../../secrets/ntfy.env;
    owner = config.users.users.ntfy-sh.name;
    group = config.users.users.ntfy-sh.group;
    format = "dotenv";
  };

  systemd.services.ntfy-sh.serviceConfig.EnvironmentFile = config.sops.secrets.ntfy.path;

  services.ntfy-sh = {
    enable = true;
    settings = {
      base-url = "https://ntfy.ixhby.dev";
      listen-http = "127.0.0.1:42069";
      behind-proxy = true;

      cache-file = "/var/lib/ntfy-sh/cache-file.db";
      cache-duration = "12h";

      auth-file = "/var/lib/ntfy-sh/user.db";
      auth-default-access = "deny-all";

      attachment-cache-dir = "/var/lib/ntfy-sh/attachments";
      attachment-total-size-limit = "5G";
      attachment-file-size-limit = "15M";
      attachment-expiry-duration = "24h";

      web-push-public-key = "BNX2aVLta5vTDFpneKffQy-UUMBRrksQBSJrkPn2uJrsWlyYqHBI6DKE9qNP-RMvFQ8GLM1lMk8BnwJZJCcYwWE";
      web-push-file = "/var/lib/ntfy-sh/webpush.db";
      web-push-email-address = "ntfy@ixhby.dev";

      keepalive-internal = "45s";
      manager-interval = "1m";

      web-root = "/";

      enable-metris = true;
      metrics-listen-http = "127.0.0.1:9834";
    };
  };

  services.nginx.upstreams.ntfy = {
    servers = {
      "127.0.0.1:42069" = {};
    };
    extraConfig = ''
    zone ntfy 64K;
    '';
  };

  services.nginx.virtualHosts."ntfy.ixhby.dev" = {
    onlySSL = true; 
    sslCertificate = "/var/lib/acme/ixhby.dev/cert.pem";
    sslCertificateKey = "/var/lib/acme/ixhby.dev/key.pem";

    locations."/" = {
      proxyPass = "http://ntfy";
      proxyWebsockets = true;

      extraConfig = ''
      proxy_connect_timeout 3m;
      proxy_send_timeout 3m;
      proxy_read_timeout 3m;

      client_max_body_size 0;
      '';
    };
  };
}
