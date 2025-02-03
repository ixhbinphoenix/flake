{ config, pkgs, lib, inputs, ... }:
{
  security.acme = {
    acceptTerms = true;
    defaults.email = "contact+acme@ixhby.dev";
  };

  networking.firewall = let
    ports = [ 80 443 8448 ];
  in {
    allowedUDPPorts = ports;
    allowedTCPPorts = ports;
  };

  users.users.nginx.extraGroups = [ "acme" ];

  services.nginx = let
    prometheus_all = pkgs.writeTextFile {
      name = "prometheus_all.conf";
      text = ''
      prometheus_template all {

        angie_connections_accepted $p8s_value
            path=/connections/accepted
            type=counter
            'help=The total number of accepted client connections.';

        angie_connections_dropped $p8s_value
            path=/connections/dropped
            type=counter
            'help=The total number of dropped client connections.';

        angie_connections_active $p8s_value
            path=/connections/active
            type=gauge
            'help=The current number of active client connections.';

        angie_connections_idle $p8s_value
            path=/connections/idle
            type=gauge
            'help=The current number of idle client connections.';

        'angie_slabs_pages_used{zone="$1"}' $p8s_value
            path=~^/slabs/([^/]+)/pages/used$
            type=gauge
            'help=The number of currently used memory pages in a slab zone.';

        'angie_slabs_pages_free{zone="$1"}' $p8s_value
            path=~^/slabs/([^/]+)/pages/free$
            type=gauge
            'help=The number of currently free memory pages in a slab zone.';

        'angie_slabs_pages_slots_used{zone="$1",size="$2"}' $p8s_value
            path=~^/slabs/([^/]+)/slots/([^/]+)/used$
            type=gauge
            'help=The number of currently used memory slots of a specific size in a slab zone.';

        'angie_slabs_pages_slots_free{zone="$1",size="$2"}' $p8s_value
            path=~^/slabs/([^/]+)/slots/([^/]+)/free$
            type=gauge
            'help=The number of currently free memory slots of a specific size in a slab zone.';

        'angie_slabs_pages_slots_reqs{zone="$1",size="$2"}' $p8s_value
            path=~^/slabs/([^/]+)/slots/([^/]+)/reqs$
            type=counter
            'help=The total number of attempts to allocate a memory slot of a specific size in a slab zone.';

        'angie_slabs_pages_slots_fails{zone="$1",size="$2"}' $p8s_value
            path=~^/slabs/([^/]+)/slots/([^/]+)/fails$
            type=counter
            'help=The number of unsuccessful attempts to allocate a memory slot of a specific size in a slab zone.';


        'angie_resolvers_queries{zone="$1",type="$2"}' $p8s_value
            path=~^/resolvers/([^/]+)/queries/([^/]+)$
            type=counter
            'help=The number of queries of a specific type to resolve in a resolver zone.';

        'angie_resolvers_sent{zone="$1",type="$2"}' $p8s_value
            path=~^/resolvers/([^/]+)/sent/([^/]+)$
            type=counter
            'help=The number of sent DNS queries of a specific type to resolve in a resolver zone.';

        'angie_resolvers_responses{zone="$1",status="$2"}' $p8s_value
            path=~^/resolvers/([^/]+)/responses/([^/]+)$
            type=counter
            'help=The number of resolution results with a specific status in a resolver zone.';


        'angie_http_server_zones_ssl_handshaked{zone="$1"}' $p8s_value
            path=~^/http/server_zones/([^/]+)/ssl/handshaked$
            type=counter
            'help=The total number of successful SSL handshakes in an HTTP server zone.';

        'angie_http_server_zones_ssl_reuses{zone="$1"}' $p8s_value
            path=~^/http/server_zones/([^/]+)/ssl/reuses$
            type=counter
            'help=The total number of session reuses during SSL handshakes in an HTTP server zone.';

        'angie_http_server_zones_ssl_timedout{zone="$1"}' $p8s_value
            path=~^/http/server_zones/([^/]+)/ssl/timedout$
            type=counter
            'help=The total number of timed-out SSL handshakes in an HTTP server zone.';

        'angie_http_server_zones_ssl_failed{zone="$1"}' $p8s_value
            path=~^/http/server_zones/([^/]+)/ssl/failed$
            type=counter
            'help=The total number of failed SSL handshakes in an HTTP server zone.';


        'angie_http_server_zones_requests_total{zone="$1"}' $p8s_value
            path=~^/http/server_zones/([^/]+)/requests/total$
            type=counter
            'help=The total number of client requests received in an HTTP server zone.';

        'angie_http_server_zones_requests_processing{zone="$1"}' $p8s_value
            path=~^/http/server_zones/([^/]+)/requests/processing$
            type=gauge
            'help=The number of client requests currently being processed in an HTTP server zone.';

        'angie_http_server_zones_requests_discarded{zone="$1"}' $p8s_value
            path=~^/http/server_zones/([^/]+)/requests/discarded$
            type=counter
            'help=The total number of client requests completed in an HTTP server zone without sending a response.';


        'angie_http_server_zones_responses{zone="$1",code="$2"}' $p8s_value
            path=~^/http/server_zones/([^/]+)/responses/([^/]+)$
            type=counter
            'help=The number of responses with a specific status in an HTTP server zone.';


        'angie_http_server_zones_data_received{zone="$1"}' $p8s_value
            path=~^/http/server_zones/([^/]+)/data/received$
            type=counter
            'help=The total number of bytes received from clients in an HTTP server zone.';

        'angie_http_server_zones_data_sent{zone="$1"}' $p8s_value
            path=~^/http/server_zones/([^/]+)/data/sent$
            type=counter
            'help=The total number of bytes sent to clients in an HTTP server zone.';


        'angie_http_location_zones_requests_total{zone="$1"}' $p8s_value
            path=~^/http/location_zones/([^/]+)/requests/total$
            type=counter
            'help=The total number of client requests in an HTTP location zone.';

        'angie_http_location_zones_requests_discarded{zone="$1"}' $p8s_value
            path=~^/http/location_zones/([^/]+)/requests/discarded$
            type=counter
            'help=The total number of client requests completed in an HTTP location zone without sending a response.';


        'angie_http_location_zones_responses{zone="$1",code="$2"}' $p8s_value
            path=~^/http/location_zones/([^/]+)/responses/([^/]+)$
            type=counter
            'help=The number of responses with a specific status in an HTTP location zone.';


        'angie_http_location_zones_data_received{zone="$1"}' $p8s_value
            path=~^/http/location_zones/([^/]+)/data/received$
            type=counter
            'help=The total number of bytes received from clients in an HTTP location zone.';

        'angie_http_location_zones_data_sent{zone="$1"}' $p8s_value
            path=~^/http/location_zones/([^/]+)/data/sent$
            type=counter
            'help=The total number of bytes sent to clients in an HTTP location zone.';


        'angie_http_upstreams_peers_state{upstream="$1",peer="$2"}' $p8st_all_ups_state
            path=~^/http/upstreams/([^/]+)/peers/([^/]+)/state$
            type=gauge
            'help=The current state of an upstream peer in "HTTP": 1 - up, 2 - down, 3 - unavailable, or 4 - recovering.';


        'angie_http_upstreams_peers_selected_current{upstream="$1",peer="$2"}' $p8s_value
            path=~^/http/upstreams/([^/]+)/peers/([^/]+)/selected/current$
            type=gauge
            'help=The number of requests currently being processed by an upstream peer in "HTTP".';

        'angie_http_upstreams_peers_selected_total{upstream="$1",peer="$2"}' $p8s_value
            path=~^/http/upstreams/([^/]+)/peers/([^/]+)/selected/total$
            type=counter
            'help=The total number of attempts to use an upstream peer in "HTTP".';


        'angie_http_upstreams_peers_responses{upstream="$1",peer="$2",code="$3"}' $p8s_value
            path=~^/http/upstreams/([^/]+)/peers/([^/]+)/responses/([^/]+)$
            type=counter
            'help=The number of responses with a specific status received from an upstream peer in "HTTP".';


        'angie_http_upstreams_peers_data_sent{upstream="$1",peer="$2"}' $p8s_value
            path=~^/http/upstreams/([^/]+)/peers/([^/]+)/data/sent$
            type=counter
            'help=The total number of bytes sent to an upstream peer in "HTTP".';

        'angie_http_upstreams_peers_data_received{upstream="$1",peer="$2"}' $p8s_value
            path=~^/http/upstreams/([^/]+)/peers/([^/]+)/data/received$
            type=counter
            'help=The total number of bytes received from an upstream peer in "HTTP".';


        'angie_http_upstreams_peers_health_fails{upstream="$1",peer="$2"}' $p8s_value
            path=~^/http/upstreams/([^/]+)/peers/([^/]+)/health/fails$
            type=counter
            'help=The total number of unsuccessful attempts to communicate with an upstream peer in "HTTP".';

        'angie_http_upstreams_peers_health_unavailable{upstream="$1",peer="$2"}' $p8s_value
            path=~^/http/upstreams/([^/]+)/peers/([^/]+)/health/unavailable$
            type=counter
            'help=The number of times when an upstream peer in "HTTP" became "unavailable" due to reaching the max_fails limit.';

        'angie_http_upstreams_peers_health_downtime{upstream="$1",peer="$2"}' $p8s_value
            path=~^/http/upstreams/([^/]+)/peers/([^/]+)/health/downtime$
            type=counter
            'help=The total time (in milliseconds) that an upstream peer in "HTTP" was "unavailable".';


        'angie_http_upstreams_keepalive{upstream="$1"}' $p8s_value
            path=~^/http/upstreams/([^/]+)/keepalive$
            type=gauge
            'help=The number of currently cached keepalive connections for an HTTP upstream.';


        'angie_http_caches_responses{zone="$1",status="$2"}' $p8s_value
            path=~^/http/caches/([^/]+)/([^/]+)/responses$
            type=counter
            'help=The total number of responses processed in an HTTP cache zone with a specific cache status.';

        'angie_http_caches_bytes{zone="$1",status="$2"}' $p8s_value
            path=~^/http/caches/([^/]+)/([^/]+)/bytes$
            type=counter
            'help=The total number of bytes processed in an HTTP cache zone with a specific cache status.';

        'angie_http_caches_responses_written{zone="$1",status="$2"}' $p8s_value
            path=~^/http/caches/([^/]+)/([^/]+)/responses_written$
            type=counter
            'help=The total number of responses written to an HTTP cache zone with a specific cache status.';

        'angie_http_caches_bytes_written{zone="$1",status="$2"}' $p8s_value
            path=~^/http/caches/([^/]+)/([^/]+)/bytes_written$
            type=counter
            'help=The total number of bytes written to an HTTP cache zone with a specific cache status.';


        'angie_http_caches_size{zone="$1"}' $p8s_value
            path=~^/http/caches/([^/]+)/size$
            type=gauge
            'help=The current size (in bytes) of cached responses in an HTTP cache zone.';


        'angie_http_caches_shards_size{zone="$1",path="$2"}' $p8s_value
            path=~^/http/caches/([^/]+)/shards/([^/]+)/size$
            type=gauge
            'help=The current size (in bytes) of cached responses in a shard path of an HTTP cache zone.';


        'angie_http_limit_conns{zone="$1",status="$2"}' $p8s_value
            path=~^/http/limit_conns/([^/]+)/([^/]+)$
            type=counter
            'help=The number of requests processed by an HTTP limit_conn zone with a specific result.';

        'angie_http_limit_reqs{zone="$1",status="$2"}' $p8s_value
            path=~^/http/limit_reqs/([^/]+)/([^/]+)$
            type=counter
            'help=The number of requests processed by an HTTP limit_reqs zone with a specific result.';


        'angie_stream_server_zones_ssl_handshaked{zone="$1"}' $p8s_value
            path=~^/stream/server_zones/([^/]+)/ssl/handshaked$
            type=counter
            'help=The total number of successful SSL handshakes in a stream server zone.';

        'angie_stream_server_zones_ssl_reuses{zone="$1"}' $p8s_value
            path=~^/stream/server_zones/([^/]+)/ssl/reuses$
            type=counter
            'help=The total number of session reuses during SSL handshakes in a stream server zone.';

        'angie_stream_server_zones_ssl_timedout{zone="$1"}' $p8s_value
            path=~^/stream/server_zones/([^/]+)/ssl/timedout$
            type=counter
            'help=The total number of timed-out SSL handshakes in a stream server zone.';

        'angie_stream_server_zones_ssl_failed{zone="$1"}' $p8s_value
            path=~^/stream/server_zones/([^/]+)/ssl/failed$
            type=counter
            'help=The total number of failed SSL handshakes in a stream server zone.';


        'angie_stream_server_zones_connections_total{zone="$1"}' $p8s_value
            path=~^/stream/server_zones/([^/]+)/connections/total$
            type=counter
            'help=The total number of client connections received in a stream server zone.';

        'angie_stream_server_zones_connections_processing{zone="$1"}' $p8s_value
            path=~^/stream/server_zones/([^/]+)/connections/processing$
            type=gauge
            'help=The number of client connections currently being processed in a stream server zone.';

        'angie_stream_server_zones_connections_discarded{zone="$1"}' $p8s_value
            path=~^/stream/server_zones/([^/]+)/connections/discarded$
            type=counter
            'help=The total number of client connections completed in a stream server zone without establishing a session.';

        'angie_stream_server_zones_connections_passed{zone="$1"}' $p8s_value
            path=~^/stream/server_zones/([^/]+)/connections/passed$
            type=counter
            'help=The total number of client connections in a stream server zone passed for handling to a different listening socket.';


        'angie_stream_server_zones_sessions{zone="$1",status="$2"}' $p8s_value
            path=~^/stream/server_zones/([^/]+)/sessions/([^/]+)$
            type=counter
            'help=The number of sessions finished with a specific status in a stream server zone.';


        'angie_stream_server_zones_data_received{zone="$1"}' $p8s_value
            path=~^/stream/server_zones/([^/]+)/data/received$
            type=counter
            'help=The total number of bytes received from clients in a stream server zone.';

        'angie_stream_server_zones_data_sent{zone="$1"}' $p8s_value
            path=~^/stream/server_zones/([^/]+)/data/sent$
            type=counter
            'help=The total number of bytes sent to clients in a stream server zone.';


        'angie_stream_upstreams_peers_state{upstream="$1",peer="$2"}' $p8st_all_ups_state
            path=~^/stream/upstreams/([^/]+)/peers/([^/]+)/state$
            type=gauge
            'help=The current state of an upstream peer in "stream": 1 - up, 2 - down, 3 - unavailable, or 4 - recovering.';


        'angie_stream_upstreams_peers_selected_current{upstream="$1",peer="$2"}' $p8s_value
            path=~^/stream/upstreams/([^/]+)/peers/([^/]+)/selected/current$
            type=gauge
            'help=The number of sessions currently being processed by an upstream peer in "stream".';

        'angie_stream_upstreams_peers_selected_total{upstream="$1",peer="$2"}' $p8s_value
            path=~^/stream/upstreams/([^/]+)/peers/([^/]+)/selected/total$
            type=counter
            'help=The total number of attempts to use an upstream peer in "stream".';


        'angie_stream_upstreams_peers_data_sent{upstream="$1",peer="$2"}' $p8s_value
            path=~^/stream/upstreams/([^/]+)/peers/([^/]+)/data/sent$
            type=counter
            'help=The total number of bytes sent to an upstream peer in "stream".';

        'angie_stream_upstreams_peers_data_received{upstream="$1",peer="$2"}' $p8s_value
            path=~^/stream/upstreams/([^/]+)/peers/([^/]+)/data/received$
            type=counter
            'help=The total number of bytes received from an upstream peer in "stream".';


        'angie_stream_upstreams_peers_health_fails{upstream="$1",peer="$2"}' $p8s_value
            path=~^/stream/upstreams/([^/]+)/peers/([^/]+)/health/fails$
            type=counter
            'help=The total number of unsuccessful attempts to communicate with an upstream peer in "stream".';

        'angie_stream_upstreams_peers_health_unavailable{upstream="$1",peer="$2"}' $p8s_value
            path=~^/stream/upstreams/([^/]+)/peers/([^/]+)/health/unavailable$
            type=counter
            'help=The number of times when an upstream peer in "stream" became "unavailable" due to reaching the max_fails limit.';

        'angie_stream_upstreams_peers_health_downtime{upstream="$1",peer="$2"}' $p8s_value
            path=~^/stream/upstreams/([^/]+)/peers/([^/]+)/health/downtime$
            type=counter
            'help=The total time (in milliseconds) that an upstream peer in "stream" was "unavailable".';
        }

        map $p8s_value $p8st_all_ups_state {
            volatile;
            "up"           1;
            "down"         2;
            "unavailable"  3;
            "recovering"   4;
            default        0;
        }
      '';
    };
  in {
    enable = true;

    package = pkgs.angie;

    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    appendHttpConfig = ''
    add_header X-Clacks-Overhead "GNU Terry Pratchett";
    include ${prometheus_all};
    '';

    upstreams = let
      default = port: name: {
        servers = {
          "127.0.0.1:${builtins.toString port}" = {};
        };
        extraConfig = ''
        zone ${name} 64K;
        '';
      };
    in {
      actual = default 5006 "actual";
      baikal = default 727 "baikal";
      conduwuit = default 6167 "conduwuit";
      cinny = default 6168 "cinny";
      forgejo = default 3000 "forgejo";
      graphana = default 1789 "grafana";
      ntfy = default 42069 "ntfy";
      searxng = default 3030 "searxng";
      uptime-kuma = default 3001 "uptime-kuma";
      zipline = default 3333 "zipline";
      navidrome = default 4533 "navidrome";
    };

    virtualHosts = let
      ssl = {
        #forceSSL = true;
        onlySSL = true;
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
      proxy_upstream = upstream: ssl // {
        locations."/".proxyPass = "http://${upstream}";
      };

      ACME_dummy = {
        enableACME = true;
        addSSL = true;
      };
    in {
      "more wine, more women, more metrics" = {
        listen = [{
          port = 1616;
          addr = "127.0.0.1";
        }{
          port = 1616;
          addr = "[::1]";
        }];

        locations."/metrics" = {
          extraConfig = ''
          prometheus all;
          '';
        };
      };
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
            proxyPass = "http://conduwuit";
            extraConfig = ''
            proxy_buffering off;
            proxy_read_timeout 5m;
            '';
          };
          "/.well-known/matrix/" = {
            proxyPass = "http://conduwuit";
            extraConfig = ''
            proxy_buffering off;
            proxy_read_timeout 5m;
            '';
          };
        };
      };
      "cinny.ixhby.dev" = (proxy_upstream "cinny") // {
        extraConfig = ''
        client_max_body_size 20M;
        '';
      };
      "budget.ixhby.dev" = proxy_upstream "actual";
      "CalDAV HTTP" = {
        serverName = "dav.ixhby.dev";
        
        extraConfig = ''
        rewrite ^/.well-known/(card|cal)dav$ /dav.php last;
        '';

        locations."/dav.php".proxyPass = "http://baikal";

        locations."/".return = "301 https://$server_name$request_uri";
      };
      "CalDAV HTTPS" = (proxy_upstream "baikal") // {
        serverName = "dav.ixhby.dev";

        extraConfig = ''
        rewrite ^/.well-known/(card|cal)dav$ /dav.php last;
        '';
      };
      "git.ixhby.dev" = ssl // {
        locations."/" = {
          proxyPass = "http://forgejo";
          extraConfig = ''
          client_max_body_size 512M;
          '';
        };
      };
      "graph.ixhby.dev" = ssl // {
        locations."/".proxyPass = "http://graphana";
        locations."/api/live" = {
          proxyPass = "http://graphana";
          proxyWebsockets = true;
        };
      };
      "ntfy.ixhby.dev" = ssl // {
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
      "search.ixhby.dev" = proxy_upstream "searxng";
      "up.ixhby.dev" = ssl // {
        extraConfig = ''
        client_max_body_size 1M;
        '';
        locations."/" = {
          proxyPass = "http://uptime-kuma";
          proxyWebsockets = true;
        };
      };
      "i.ixhby.dev" = proxy_upstream "zipline";
      "navi.ixhby.dev" = proxy_upstream "navidrome";

      "garnix.dev" = ssl // {
        root = inputs.garnix-dev.packages.${pkgs.system}.default;

        locations."/" = {
          index = "index.html";
          tryFiles = "$uri $uri.html $uri/ $uri/index.html =404";
        };
      };
    };
  };
}
