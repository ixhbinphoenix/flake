{ config, lib, ... }: {

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
        extraDomainNames = [ "*.${domain}" ];
      };
    in {
      "garnix.dev" = wildcard "garnix.dev";
      "ixhby.dev" = wildcard "ixhby.dev";
    };
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
