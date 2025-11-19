{ inputs, ... }: { 
  imports = [
    ./hardware-configuration.nix
    ./networking.nix
  ];

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/vda";

  time.timeZone = "Europe/Berlin";

  sops.defaultSopsFile = ../../secrets/lucy.yaml;

  stages.server = {
    enable = true;

    metrics.enable = true;
    services = {
      nginx = {
        enable = true;
        domains = [ "garnix.dev" "ixhby.dev" ];
        internalDomains = true;
      };
      slskd.enable = true;
      navidrome.enable = true;
      searxng.enable = true;
      ntfy.enable = true;
      forgejo.enable = true;
      zipline.enable = true;
      garnix.enable = true;
      unbound.enable = true;
      immich.enable = true;
    };
  };

  nixpkgs.overlays = [ inputs.nix-minecraft.overlay ];
  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "25.05";
}

