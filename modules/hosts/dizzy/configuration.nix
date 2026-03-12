{ inputs, ... }: {
  flake.modules.nixos.dizzy = {
    imports = with inputs.self.modules.nixos; [
      systemd-boot
      phoenix
      minimal
    ];

    system.stateVersion = "23.05";
  };
}
