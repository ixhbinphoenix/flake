{...}: {
  services.unbound = {
    enable = true;
    enableRootTrustAnchor = true;
    checkconf = true;

    settings = {
      server = {
        interface = [ "0.0.0.0" "::0" ];
        access-control = [ "192.168.0.0/16 allow" "fe80::/10 allow" ];
        port = 53;

        hide-identity = true;
        hide-version = true;

        harden-glue = true;
        harden-dnssec-stripped = true;
        use-caps-for-id = false;

        prefetch = true;

        so-rcvbuf = "1m";

        private-address = [ "192.168.0.0/16" "10.0.0.0/8" "fe80::/10" ];

        local-zone = [ "internal.ixhby.dev. static" ];
        local-data = [
          "'bridget.internal.ixhby.dev. A 192.168.178.2'"

          "'lucy.internal.ixhby.dev. A 192.168.178.22'"
          "'immich.internal.ixhby.dev. A 192.168.178.22'"

          "'dizzy.internal.ixhby.dev. A 192.168.178.23'"
        ];
      };
    };
  };

  networking.firewall.allowedTCPPorts = [ 53 ];
  networking.firewall.allowedUDPPorts = [ 53 ];
}
