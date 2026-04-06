{ inputs, ... }: {
  flake.modules.nixos.default-pc = {
    imports = with inputs.self.modules.nixos; with inputs.self.factory; [
      nixos_minimal
      home-manager
      nur
      fonts
      (greetd "niri-session")
      kdeconnect
    ];
  };
}
