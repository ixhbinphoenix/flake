{ inputs, ... }: {
  flake.modules.nixos.dizzy = {
    imports = with inputs.self.modules.nixos; [
      systemd-boot
      default-pc
      phoenix
    ];

    system.stateVersion = "23.05";
  };
}
