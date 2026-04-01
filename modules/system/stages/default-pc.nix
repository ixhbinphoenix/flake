{ inputs, ... }: {
  flake.modules.nixos.default-pc = {
    imports = with inputs.self.modules.nixos; [
      nixos_minimal
      home-manager
      nur
      fonts
    ];
  };
}
