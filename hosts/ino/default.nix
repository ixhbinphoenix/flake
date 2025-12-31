{ pkgs, config, lib, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./networking.nix # generated at runtime by nixos-infect
  ];

  boot.tmp.cleanOnBoot = true;
  #zramSwap.enable = true;

  networking.hostName = "ino";
  networking.domain = "ino.internal.ixhby.dev";

  stages.server = {
    enable = true;
  };

  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
  };

  sops = {
    secrets."wg0.key" = {
      sopsFile = ../../secrets/wireguard/ino/private.key;
      format = "binary";
    };
    secrets."wg1.key" = {
      sopsFile = ../../secrets/wireguard/ino/wg1.private.key;
      format = "binary";
    };
  };

  #
  # ino (VPS)
  #

  networking.wireguard = {
    enable = true;
    interfaces = {
      "wg0" = {
        privateKeyFile = config.sops.secrets."wg0.key".path;
        listenPort = 51820;
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

      # Hub and Spoke Point-to-site VPN
      "wg1" = {
        privateKeyFile = config.sops.secrets."wg1.key".path;
        listenPort = 51821;
        ips = [
          "10.1.0.3/32"
        ];

        peers = [
        {
          name = "ramlethal";
          publicKey = "TTqZr5e60YtgBFYrzS2+K5KgFZyZQ0arWukzv9AlyTo=";
          allowedIPs = [
            "10.1.0.1/32"
          ];
        }
        {
          name = "axl";
          publicKey = "iWbimRyfBsRgze8Dp2U50FkDbrU8lERz41Gdgr8sa1o=";
          allowedIPs = [
            "10.1.0.2/32"
            "192.168.178.0/24"
          ];
        }
        ];
      };
    };
  };

  networking.firewall.allowedUDPPorts = [ 51820 51821 ];

  system.stateVersion = "23.11";
}
