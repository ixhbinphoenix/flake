{ config, lib, pkgs, ... }:
with lib;
{
  options.wireguard = {
    enable = mkEnableOption "Wireguard VPN (through networkmanager)";
  };

  config = mkIf config.wireguard.enable (mkMerge([
  {
    environment.systemPackages = with pkgs; [
      wireguard-tools wireguard-go
    ];

    # boot.extraModulePackages = [ config.boot.kernelPackages.wireguard ];

    networking.firewall = {
      allowedUDPPorts = [ 51820 ];
      logReversePathDrops = true;

      extraCommands = ''
        ip46tables -t mangle -I nixos-fw-rpfilter -p udp -m udp --sport 51820 -j RETURN
        ip46tables -t mangle -I nixos-fw-rpfilter -p udp -m udp --dport 51820 -j RETURN
      '';
      extraStopCommands = ''
        ip46tables -t mangle -D nixos-fw-rpfilter -p udp -m udp --sport 51820 -j RETURN || true
        ip46tables -t mangle -D nixos-fw-rpfilter -p udp -m udp --dport 51820 -j RETURN || true
      '';
    };
  }
  ]));
}
