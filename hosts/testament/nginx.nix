{ config, pkgs, lib, inputs, ... }:
{
  security.acme = {
    acceptTerms = true;
    defaults.email = "phoenix@ixhby.dev";
  };

  networking.firewall = let
    ports = [ 80 443 8448 ];
  in {
    allowedUDPPorts = ports;
    allowedTCPPorts = ports;
  };

  services.nginx = {
    enable = true;

    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    appendHttpConfig = ''
    add_header X-Clacks-Overhead "GNU Terry Pratchett";
    '';

    virtualHosts = let
      ssl = {
        forceSSL = true;
        enableACME = true;
      };

      SSLv4 = port: {
        inherit port;
        addr = "0.0.0.0";
        ssl = true;
      };
      SSLv6 = port: {
        inherit port;
        addr = "[::0]";
        ssl = true;
      };
      defaultListen = [
        (SSLv4 443)
        (SSLv6 443)
      ];

      proxy = port: ssl // {
        locations."/".proxyPass = "http://127.0.0.1:${builtins.toString port}";
      };
    in {
      "ixhby.dev" = ssl // {
        listen = defaultListen ++ [
          (SSLv4 8448)
          (SSLv6 8448)
        ];

        extraConfig = ''
        merge_slashes off;
        '';

        locations = {
          "/_matrix/" = {
            proxyPass = "http://127.0.0.1:6167";
            extraConfig = ''
            proxy_buffering off;
            proxy_read_timeout 5m;
            '';
          };
          "/.well-known/matrix/" = {
            proxyPass = "http://127.0.0.1:6167";
            extraConfig = ''
            proxy_buffering off;
            proxy_read_timeout 5m;
            '';
          };
        };
      };
      "cinny.ixhby.dev" = (proxy 6167) // {
        extraConfig = ''
        client_max_body_size 20M;
        '';
      };
      "budget.ixhby.dev" = proxy 5006;
      "CalDAV HTTP" = {
        serverName = "dav.ixhby.dev";
        
        extraConfig = ''
        rewrite ^/.well-known/(card|cal)dav$ /dav.php last;
        '';

        locations."/dav.php".proxyPass = "http://127.0.0.1:727";

        locations."/".return = "301 https://$server_name$request_uri";
      };
      "CalDAV HTTPS" = (proxy 727) // {
        serverName = "dav.ixhby.dev";

        extraConfig = ''
        rewrite ^/.well-known/(card|cal)dav$ /dav.php last;
        '';
      };
      "dock.ixhby.dev" = ssl // {
        extraConfig = ''
        client_max_body_size 1M;
        '';
        locations."/" = {
          proxyPass = "http://127.0.0.1:5001";
          proxyWebsockets = true;
        };
      };
      "git.ixhby.dev" = ssl // {
        locations."/" = {
          proxyPass = "http://127.0.0.1:3000";
          extraConfig = ''
          client_max_body_size 512M;
          '';
        };
      };
      "graph.ixhby.dev" = ssl // {
        locations."/".proxyPass = "http://127.0.0.1:1789";
        locations."/api/live" = {
          proxyPass = "http://127.0.0.1:1789";
          proxyWebsockets = true;
        };
      };
      "ntfy.ixhby.dev" = ssl // {
        locations."/" = {
          proxyPass = "http://127.0.0.1:42069";
          proxyWebsockets = true;

          extraConfig = ''
          proxy_connect_timeout 3m;
          proxy_send_timeout 3m;
          proxy_read_timeout 3m;

          client_max_body_size 0;
          '';
        };
      };
      "search.ixhby.dev" = proxy 3030;
      "up.ixhby.dev" = ssl // {
        extraConfig = ''
        client_max_body_size 1M;
        '';
        locations."/" = {
          proxyPass = "http://127.0.0.1:3001";
          proxyWebsockets = true;
        };
      };
      "i.ixhby.dev" = proxy 3333;

      "garnix.dev" = ssl // {
        root = "/opt/garnix.dev";

        locations."/" = {
          index = "index.html";
          tryFiles = "$uri $uri/ $uri/index.html =404";
        };
      };
    };
  };
}
