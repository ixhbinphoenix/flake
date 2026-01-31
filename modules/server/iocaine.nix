{ config, pkgs, lib, ... }: {
  options.stages.server.services.iocaine = {
    enable = lib.mkEnableOption "";
  };

  config = let
    cfg = config.stages.server.services.iocaine;
  in lib.mkIf cfg.enable {
    services.iocaine =  {
      enable = true;

      config = {
        server = {
          default = {
            bind = "127.0.0.1:1984";
            mode = "http";
            use.handler-from = "nam-shub-of-enki";
            use.metrics = "metrics";
          };  
          metrics = {
            bind = "127.0.0.1:1985";
            mode = "prometheus";
            persist-path = "qmk-metrics.json";
            persist-interval = "1h";
          };
        };

        handler.nam-shub-of-enki = {
          path = pkgs.nam-shub-of-enki;
          inherits = "default";

          sources = {
            training-corpus = [
              (pkgs.fetchurl {
                url = "https://ia803102.us.archive.org/2/items/Manifesto_201807/Manifesto_djvu.txt";
                hash = "sha256-Uxz78qm5l4wN/9iIof0jMQ7qcXJ8Ld0Nxh1hiPLwf+0=";
              })
            ];
          };

          logging = {
            enable = true;
            classification.enable = true;
          };

          checks = {
            ai-robots-txt = {
              enable = true;
              path = pkgs.fetchFromGitHub {
                owner = "ai-robots-txt";
                repo = "ai.robots.txt";
                rev = "aa8519ec107d7cfa29b03005c9176708e1269965";
                hash = "sha256-O/W/gX7EazxzR+ghdxg4i6S0SHEUZoX1afB//HKUNgY=";
              } + "/robots.json";
            };
            cookie-monster = {
              enable = true;
              forgejo-hosts = [ "git.ixhby.dev" ];
            };
            generated_urls = {
              enable = true;
              identifiers = [ "itspeaksinathousandvoices" ];
            };
            firefox_ai.enable = true;
            cloudfare_workers.enable = true;
            archivers.enable = true;
            headless_browsers.enable = true;
            fake_agents.enable = true;
            browser_verification.enable = true;
            anti_robots_txt.enable = true;
            big_tech.enable = true;
            commercial_scrapers.enable = true;
            unwanted_fedi_software.enable = true; # kinda useless? but just in case
          };
        };
      };
    };

    services.nginx.upstreams.iocaine = {
      servers = {
        "127.0.0.1:1984" = {};
      };
      extraConfig = ''
      zone iocaine 64K;
      '';
    };

    stages.server.services.nginx.iocaine = {
      enable = true;
      upstream = "iocaine";
    };
  };
}
