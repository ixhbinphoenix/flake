{ inputs, ... }: {
  flake.modules.nixos.ramlethal = {
    imports = with inputs.self.modules.nixos; [
      systemd-boot
      gaming-nixos
      phoenix
    ];

    system.stateVersion = "24.11";
  };
}
