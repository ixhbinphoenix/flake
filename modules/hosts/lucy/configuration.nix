{ inputs, ... }: {
  flake.modules.nixos.lucy = {
    imports = with inputs.self.modules.nixos; [
      default-server

      nginx
      iocaine
      forgejo
      immich
      metrics
      ntfy
      searxng
      unbound
      zipline

      media
      copyparty
      jellyfin
      navidrome
      slskd
    ];

    system.stateVersion = "25.05";
  };
}
