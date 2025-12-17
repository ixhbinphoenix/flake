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
          "10.0.0.1/24" "fd42:42:42::1/64"
        ];

        postSetup = ''
        ${pkgs.iptables}/bin/iptables -A FORWARD -i wg0 -j ACCEPT
        ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -o end0 -j MASQUERADE
        '';
        postShutdown = ''
        ${pkgs.iptables}/bin/iptables -D FORWARD -i wg0 -j ACCEPT
        ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -o end0 -j MASQUERADE
        '';

        peers = [];
      };
    };
  };

  networking.firewall.allowedUDPPorts = [ 51820 ];

  system.stateVersion = "26.05";
}

