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
    };
  };

  networking.firewall.allowedUDPPorts = [ 51820 ];

  system.stateVersion = "23.11";
}
