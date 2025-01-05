{ config, pkgs, lib, inputs, ... }:
{
  services.prometheus = {
    enable = true;

    scrapeConfigs = [
      {
        job_name = "prometheus";
        scrape_interval = "5s";
        static_configs = [{
          targets = [
            "localhost:9090"
          ];
        }];
      }
      {
        job_name = "ntfy";
        static_configs = [{
          targets = [
            "localhost:9834"
          ];
        }];
      }
      {
        job_name = "node_exporter";
        static_configs = [{
          targets = [
            "localhost:9100"
          ];
        }];
      }
      {
        job_name = "cadvisor";
        static_configs = [{
          targets = [
            "localhost:8123"
          ];
        }];
      }
      # TODO: Uptime Kuma metrics
      {
        job_name = "forgejo";
        #bearer_token_file = config.sops.secrets."forgejo/metrics/TOKEN".path;
        static_configs = [{
          targets = [
            "localhost:3000"
          ];
        }];
      }
      {
        job_name = "angie";
        scrape_interval = "15s";
        static_configs = [{
          targets = [
            "localhost:1616"
          ];
        }];
      }
      {
        job_name = "loki";
        static_configs = [{
          targets = [
            "localhost:3100"
          ];
        }];
      }
      {
        job_name = "promtail";
        static_configs = [{
          targets = [
            "localhost:3101"
          ];
        }];
      }
    ];

    exporters = {
      node = {
        enable = true;
        port = 9100;
      };
    };
  };

  services.promtail = {
    enable = true;
    configuration = {
      server = {
        http_listen_address = "127.0.0.1";
        http_listen_port = 3101;
        grpc_listen_address = "127.0.0.1";
        grpc_listen_port = 0;
      };
      clients = [{
        url = "http://localhost:3100/loki/api/v1/push";
      }];
      scrape_configs = [
        {
          # TODOO: Angie logs are broken
          job_name = "angie";
          static_configs = [{
            targets = [ "localhost" ];
            labels = {
              job = "angie";
              instance = "localhost:3101";
              __path__ = "/var/log/nginx/*.log";
            };
          }];
        }
        {
          job_name = "journal";
          journal = {
            json = false;
            max_age = "12h";
            path = "/var/log/journal";
            labels = {
              job = "promtail";
              instance = "localhost:3101";
            };
          };
          relabel_configs = [
            {
              source_labels = ["__journal_systemd_unit"];
              target_label = "unit";
            }
            {
              source_labels = ["__journal_systemd_unit"];
              action = "keep";
              regex = "promtail.service";
            }
          ];
        }
      ];
    };
  };

  services.cadvisor = {
    enable = true;
    port = 8123;
  };


  services.grafana = {
    enable = true;

    settings = {
      server = {
        protocol = "http";
        http_port = 1789;
        http_addr = "127.0.0.1";

        domain = "graph.ixhby.dev";

        root_url = "https://%(domain)s/";
      };
    };
  };

  services.loki = {
    enable = true;
    configuration = {
      # Whole thing stolen from latte's config
      # TODO: figure out what most of this stuff does
      auth_enabled = false;

      common = {
        instance_addr = "127.0.0.1";
        path_prefix = "/tmp/loki";
        storage.filesystem = {
          chunks_directory = "/var/lib/loki/chunks";
          rules_directory = "/var/lib/loki/rules";
        };
        replication_factor = 1;
        ring.kvstore.store = "inmemory";
      };

      query_scheduler.max_outstanding_requests_per_tenant = 4096;

      query_range.results_cache.cache.embedded_cache = {
        enabled = true;
        max_size_mb = 100;
      };

      schema_config.configs = [
        {
          from = "2025-01-04";
          store = "tsdb";
          object_store = "filesystem";
          schema = "v13";
          index = {
            prefix = "index_";
            period = "24h";
          };
        }
      ];

      querier.max_concurrent = 20;

      server = {
        http_listen_port = 3100;
        http_server_read_timeout = "60s";  # allow longer time span queries
        http_server_write_timeout = "60s"; # allow longer time span queries
        grpc_server_max_recv_msg_size = 33554432; # 32 MiB (int bytes), default 4MB
        grpc_server_max_send_msg_size = 33554432; # 32 MiB (int bytes), default 4MB

        log_level = "info";
      };

      frontend = {
        max_outstanding_per_tenant = 2048;
        compress_responses = true;
        log_queries_longer_than = "20s";
      };

      compactor = {
        retention_enabled = true;
        delete_request_store = "filesystem";
      };

      limits_config = {
        retention_period = "200d";
        allow_structured_metadata = true;
        split_queries_by_interval = "2h";
      };
    };
  };
}
