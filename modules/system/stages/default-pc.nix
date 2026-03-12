{ inputs, ... }: {
  flake.modules.nixos.default-pc = {
    imports = with inputs.self.modules.nixos; [
      minimal
      home-manager
      nur
    ];
  };
}
