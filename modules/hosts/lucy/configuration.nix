{ inputs, ... }: {
  flake.modules.nixos.lucy = {
    imports = with inputs.self.modules.nixos; [
    ];

    system.stateVersion = "25.05";
  };
}
