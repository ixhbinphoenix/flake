{ inputs, ... }: {
  flake.modules.nixos.ramlethal = {
    imports = with inputs.self.modules.nixos; [
      systemd-boot
    ];

    system.stateVersion = "24.11";
  };
}
