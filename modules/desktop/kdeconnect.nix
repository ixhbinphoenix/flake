{
  flake.modules.nixos.kdeconnect = { pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      kdePackages.kdeconnect-kde
      kdePackages.plasma-browser-integration
    ];

    networking.firewall.allowedUDPPorts = pkgs.lib.lists.range 1714 1764 ;
    networking.firewall.allowedTCPPorts = pkgs.lib.lists.range 1714 1764 ;
  };
}
