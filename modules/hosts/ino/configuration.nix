{ inputs, ... }: {
  flake.modules.nixos.ino = {
    imports = with inputs.self.modules.nixos; [
      default-server
    ];

    system.stateVersion = "25.05";
  };
}
