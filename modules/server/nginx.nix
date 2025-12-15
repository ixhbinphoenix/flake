{ config, lib, ... }: {
  options.stages.server.services.nginx = {
    enable = lib.mkEnableOption "Barebones nginx config with ACME";

    domains = lib.mkOption {
      type = lib.types.nonEmptyListOf lib.types.nonEmptyStr;
      default = [
        "garnix.dev"
        "ixhby.dev"
        "faggirl.gay"
      ];
    };
    internalDomains = lib.mkEnableOption "*.internal.domain domains";
  };

  config = let
    cfg = config.stages.server.services.nginx;
  in lib.mkIf cfg.enable (lib.mkMerge [{
    sops.secrets.acme = {
      sopsFile = ../../secrets/acme.env;
      format = "dotenv";
    };

    security.acme = {
      acceptTerms = true;

      certs = let
        pork = {
          dnsProvider = "porkbun";
          webroot = lib.mkForce null;
          email = "contact+acme@ixhby.dev";
          environmentFile = config.sops.secrets.acme.path;
        };
        wildcard = domain: pork // {
          extraDomainNames = [ "*.${domain}" ] ++ (if cfg.internalDomains then [ "*.internal.${domain}" ] else []);
        };
        listToSet = domains: builtins.listToAttrs (builtins.map (x: { name = x; value = (wildcard x);}) domains);
      in (listToSet cfg.domains);
    };

    users.users.nginx.extraGroups = [ "acme" ];

    networking.firewall = {
      allowedTCPPorts = [ 80 443 ];
      allowedUDPPorts = [ 80 443 ];
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
    };
  }
  ]);

}
