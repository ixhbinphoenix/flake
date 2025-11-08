{ config, lib, ... }: {
  options.stages.server.metrics = {
    enable = lib.mkEnableOption "";
  };

  config = let
    cfg = config.stages.server.metrics;
  in lib.mkIf cfg.enable {
    sops.secrets.vmAuth = {
      sopsFile = ../../secrets/vmAuth.txt;
      format = "binary";
    };

    services.victoriametrics = {
      enable = true;
      listenAddress = "0.0.0.0:8428";
      basicAuthUsername = "vm";
      basicAuthPasswordFile = config.sops.secrets.vmAuth.path;

      prometheusConfig = {
        scrape_configs = [
          {
            job_name = "node-exporter";
            metrics_path = "/metrics";
            static_configs = [
              {
                targets = ["127.0.0.1:${builtins.toString config.services.prometheus.exporters.node.port}"];
                labels.type = "node";
              }
            ];
          }
          {
            job_name = "wireguard-exporter";
            metrics_path = "/metrics";
            static_configs = [
              {
                targets = ["127.0.0.1:${builtins.toString config.services.prometheus.exporters.wireguard.port}"];
              }
            ];
          }
          {
            job_name = "postgres-exporter";
            metrics_path = config.services.prometheus.exporters.postgres.telemetryPath;
            static_configs = [
              {
                targets = ["127.0.0.1:${builtins.toString config.services.prometheus.exporters.postgres.port}"];
              }
            ];
          }
          {
            job_name = "pve-exporter";
            static_configs = [
              {
                targets = ["bridget.internal.ixhby.dev:8006"];
              }
            ];
            metrics_path = "/pve";
            params = {
              module = ["default"];
              cluster = ["1"];
              node = ["1"];
            };
            relabel_configs = [
            {
              source_labels = ["__address__"];
              target_label = "__param_target";
            }
            {
              source_labels = ["__param_target"];
              target_label = "intance";
            }
            {
              target_label = "__address__";
              replacement = "127.0.0.1:9221";
            }
            ];
          }
        ];
      };
    };

    sops.secrets.pve = {
      sopsFile = ../../secrets/pve.txt;
      format = "binary";
    };

    services.prometheus.exporters = {
      node = {
        enable = true;
        enabledCollectors = [ "systemd" ];
      };
      wireguard = {
        enable = true;
        withRemoteIp = true;
      };
      postgres = {
        enable = true;
      };
      pve = {
        enable = true;
        configFile = config.sops.secrets.pve.path;
      };
    };

    services.grafana = {
      enable = true;

      settings = {
        server = {
          protocol = "http";
          http_port = 1789;
          http_addr = "127.0.0.1";

          domain = "m.ixhby.dev";

          root_url = "https://%(domain)s/";
        };
      };
    };

    # TODO: grafana-to-ntfy
    # note: needs secrets through systemd

    services.nginx.upstreams = {
      grafana = {
        servers = {
          "127.0.0.1:${builtins.toString config.services.grafana.settings.server.http_port}" = {};
        };
        extraConfig = ''
        zone grafana 64K;
        '';
      };
      victoriametrics = {
        servers = {
          "127.0.0.1:8428" = {};
        };
        extraConfig = ''
        zone victoriametrics 64K;
        '';
      };
    };

    services.nginx.virtualHosts."m.ixhby.dev" = {
      onlySSL = true;
      sslCertificate = "/var/lib/acme/ixhby.dev/cert.pem";
      sslCertificateKey = "/var/lib/acme/ixhby.dev/key.pem";

      locations."/" = {
        proxyPass = "http://grafana";
      };
    };
    services.nginx.virtualHosts."vm.ixhby.dev" = {
      onlySSL = true;
      sslCertificate = "/var/lib/acme/ixhby.dev/cert.pem";
      sslCertificateKey = "/var/lib/acme/ixhby.dev/key.pem";

      locations."/" = {
        proxyPass = "http://victoriametrics";
      };
    };
  };
}
