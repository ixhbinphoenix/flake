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
    ];

    exporters = {
      node = {
        enable = true;
        port = 9100;
      };
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
        http_port = 3000;
        http_addr = "127.0.0.1";

        domain = "graph.ixhby.dev";

        root_url = "https://%(domain)s/";
      };
    };
  };
}
