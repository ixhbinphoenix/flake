{
  flake.modules.nixos.iocaine = {pkgs, lib, ...}: {
    services.iocaine = {
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
                rev = "f420408eee6c6a8c4eaf3536d6f9c926c9b01fa4";
                hash = lib.fakeHash;
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
            cloudflare_workers.enable = true;
            archivers.enable = true;
            headless_browsers.enable = true;
            fake_agents.enable = true;
            browser_verfication.enable = true;
            anti_robots_txt.enable = true;
            big_tech.enable = true;
            commercial_scrapers.enable = true;
            unwanted_fedi_software.enable = true;
          };
        };
      };
    };
  };
}
