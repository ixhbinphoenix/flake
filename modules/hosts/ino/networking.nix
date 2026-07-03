{
  flake.modules.nixos.ino = { config, pkgs, lib, ... }: {
    networking = {
      nameservers = [ "8.8.8.8" "8.8.4.4" ];

      defaultGateway = "45.81.233.1";
      defaultGateway6 = {
        address = "";
        interface = "eth0";
      };
      dhcpcd.enable = false;
      usePredictableInterfaceNames = lib.mkForce false;

      interfaces = {
        eth0 = {
          ipv4.addresses = [
            { address="45.81.233.66"; prefixLength=24; }
            { address="45.81.235.222"; prefixLength=24; }
          ];
          ipv6.addresses = [
            { address="fe80::4c65:4ff:fe2f:e02a"; prefixLength=64; }
          ];
          ipv4.routes = [
            { address = "45.81.233.1"; prefixLength = 32; }
          ];
        };
      };
    };

    services.udev.extraRules = ''
      ATTR{address}=="4e:65:04:2f:e0:2a", NAME="eth0"

    '';

    boot.kernel.sysctl = {
      "net.ipv4.ip_forward" = 1;
    };

    sops.secrets = {
      "wg0.key" = {
        sopsFile = ../../../secrets/wireguard/ino/private.key;
        format = "binary";
      };
    };

    networking.firewall.allowedUDPPorts = [ 51820 ];

    networking.wireguard = {
      enable = true;
      interfaces = {
        "wg0" = {
          privateKeyFile = config.sops.secrets."wg0.key".path;
          listenPort = 51820;
          mtu = 1350;
          ips = [
            "10.0.1.1/24"
          ];

          postSetup = ''
          ${pkgs.iptables}/bin/iptables -t nat -A PREROUTING -d 45.81.235.222 -j DNAT --to-destination 10.0.2.2
          ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -j MASQUERADE
          '';

          postShutdown = ''
          ${pkgs.iptables}/bin/iptables -t nat -D PREROUTING -d 45.81.235.222 -j DNAT --to-destination 10.0.2.2
          ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -j MASQUERADE
          '';

          peers = [
          {
            name = "lucy";
            publicKey = "cuK0XiL42gB15FW7Mq7N9zbP+ItVTgdB79n61KhMgCU=";
            allowedIPs = [
              "10.0.2.2/32"
            ];
          }
          ];
        };
      };
    };
  };
}
