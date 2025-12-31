{ pkgs, config, ... }: {
  imports = [
      ./hardware-configuration.nix
  ];

  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;

  networking.hostName = "axl";
  networking.domain = "axl.internal.ixhby.dev";

  stages.server = {
    enable = true;
  };

  time.timeZone = "Europe/Berlin";

  environment.systemPackages = with pkgs; [
    neovim
    raspberrypi-eeprom
    libraspberrypi
  ];

  services.openssh.enable = true;

  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
  };

  sops = {
    secrets."wg0.key" = {
      sopsFile = ../../secrets/wireguard/axl/private.key;
      format = "binary";
    };
  };

  # Axl (pi, point-to-site vpn server)
  networking.wireguard = {
    enable = true;
    interfaces = {
      "wg0" = {
        privateKeyFile = config.sops.secrets."wg0.key".path;
        listenPort = 51820;
        ips = [
          "10.1.0.2/32"
        ];

        peers = [
        {
          name = "ino";
          endpoint = "45.81.233.66:51821";
          publicKey = "vVZn+0CrS9dMBljXPEfRFUghplyopQDMUevsTnfWz38=";
          allowedIPs = [
            "10.1.0.0/24"
          ];
          persistentKeepalive = 25;
        }
        ];
      };
    };
  };

  networking.firewall.allowedUDPPorts = [ 51820 ];

  system.stateVersion = "26.05";
}

