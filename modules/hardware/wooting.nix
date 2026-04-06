{
  flake.modules.nixos.wooting = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      wootility
    ];

    services.udev.packages = with pkgs; [ wooting-udev-rules ];
  };
}
