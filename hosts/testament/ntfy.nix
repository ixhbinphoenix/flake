{ config, pkgs, lib, inputs, ... }:
{
  services.ntfy-sh = {
    enable = true;
    settings = {
      base-url = "https://ntfy.ixhby.dev";
      listen-http = "127.0.0.1:42069";
      behind-proxy = true;

      cache-file = "/var/cache/ntfy/cache.db";
      cache-duration = "12h";

      auth-file = "/var/lib/ntfy/user.db";
      auth-default-access = "deny-all";

      attachment-cache-dir = "/var/cache/ntfy/attachments";
      attachment-total-size-limit = "5G";
      attachment-file-size-limit = "15M";
      attachment-expiry-duration = "24h";

      smtp-sender-addr = "mail.mailtwo24.de:587";
      smtp-sender-from = "ntfy@ixhby.dev";
      smtp-sender-user = "ntfy@ixhby.dev";
      # TODOOOOOO: Set up nix secrets
      smtp-sender-pass = "TODO: Set up nix secrets";

      web-push-public-key = "BNX2aVLta5vTDFpneKffQy-UUMBRrksQBSJrkPn2uJrsWlyYqHBI6DKE9qNP-RMvFQ8GLM1lMk8BnwJZJCcYwWE";
      web-push-private-key = "TODO: Set up nix secrets";
      web-push-file = "/var/cache/ntfy/webpush.db";
      web-push-email-address = "ntfy@ixhby.dev";

      keepalive-internal = "45s";
      manager-interval = "1m";

      web-root = "/";

      enable-metris = true;
      metrics-listen-http = "127.0.0.1:9834";

      log-level = "info";
      log-format = "json";
      log-file = "/var/log/ntfy.log";
    };
  };
}
