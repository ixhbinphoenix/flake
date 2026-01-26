{ config, lib, ... }: {
  options.stages.server.services.nginx = let
    types = lib.types;
  in {
    enable = lib.mkEnableOption "Barebones nginx config with ACME";

    domains = lib.mkOption {
      type = types.nonEmptyListOf types.nonEmptyStr;
      default = [
        "garnix.dev"
        "ixhby.dev"
        "faggirl.gay"
      ];
    };
    internalDomains = lib.mkEnableOption "*.internal.domain domains";

    iocaine = {
      enable = lib.mkEnableOption "enable iocaine" // {
        default = config.stages.server.services.iocaine.enable;
      };
      upstream = lib.mkOption {
        type = types.str;
        example = "127.0.0.1:1984";
        default = "${config.services.iocaine.config.server.default.bind}";
      };
    };

    vhosts = lib.mkOption {
      type = types.attrsOf (
        types.submodule {
          options = {
            service_name = lib.mkOption {
              type = types.nonEmptyStr;
            };
            protocol = lib.mkOption {
              type = types.enum [ "http" "https" ];
            };
            servers = lib.mkOption {
              type = types.listOf types.str;
              example = [ "127.0.0.1:42069" "unix:/dev/shm/upstream.sock" ];
            };
            cert_path = lib.mkOption {
              type = types.nonEmptyStr;
              example = "faggirl.gay";
            };
            extraConfig = lib.mkOption {
              type = types.lines;
              default = "";
            };
          };
        }
      );
      default = {};
    };
  };

  config = let
    cfg = config.stages.server.services.nginx;

    protocol_to_prefix = p: if p == "http" then
      "http://"
    else if p == "https" then
      "https://"
    else
      "";
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
        listToSet = domains: builtins.listToAttrs (map (x: { name = x; value = (wildcard x);}) domains);
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

      appendHttpConfig = if cfg.iocaine.enable then
        builtins.concatStringsSep "\n" (lib.mapAttrsToList (_: x: "
        map $request_method $upstream_location_${x.service_name} {
          GET http://${cfg.iocaine.upstream};
          HEAD http://${cfg.iocaine.upstream};
          default ${protocol_to_prefix x.protocol}${x.service_name};
        }
        ") cfg.vhosts)
      else
        "";

      upstreams = builtins.listToAttrs (lib.mapAttrsToList (_: x: {
        name = x.service_name;
        value = {
          servers = builtins.listToAttrs (map (y: {
            name = y;
            value = {};
          }) x.servers);
          extraConfig = ''
          zone ${x.service_name} 64K;
          '';
        };
      }) cfg.vhosts);

      virtualHosts = builtins.mapAttrs (_: x: {
        onlySSL = true;
        sslCertificate = "/var/lib/acme/${x.cert_path}/cert.pem";
        sslCertificateKey = "/var/lib/acme/${x.cert_path}/key.pem";

        extraConfig = if cfg.iocaine.enable then
          "recursive_error_pages on;"
        else
          "";

        locations."/" = if cfg.iocaine.enable then {
          proxyPass = "$upstream_location_${x.service_name}";
          extraConfig = ''
          proxy_intercept_errors on;
          error_page 421 = @fallback;
          '' + x.extraConfig;
        } else {
          inherit (x) extraConfig;
          proxyPass = "${protocol_to_prefix x.protocol}${x.service_name}";
        };

        locations."@fallback" = lib.mkIf cfg.iocaine.enable {
          inherit (x) extraConfig;
          proxyPass = "${protocol_to_prefix x.protocol}${x.service_name}";
        };
      }) cfg.vhosts;
    };
  }
  ]);

}
