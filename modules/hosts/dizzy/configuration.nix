{ inputs, ... }: {
  flake.modules.nixos.dizzy = {
    imports = with inputs.self.modules.nixos; [
      systemd-boot
      gaming-nixos
      phoenix
    ];

    system.stateVersion = "23.05";
  };
}
