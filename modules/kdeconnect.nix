{ pkgs, lib, ... }:
{
  imports = [];

  options = {};

  config = {
    environment.systemPackages = with pkgs; [ libsForQt5.kdeconnect-kde kdePackages.plasma-browser-integration ];

    networking.firewall.allowedUDPPorts = lib.lists.range 1714 1764;
    networking.firewall.allowedTCPPorts = lib.lists.range 1714 1764;
  };
}
