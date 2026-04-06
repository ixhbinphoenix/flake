{ inputs, ... }: {
  flake.modules.nixos.default-pc = {
    imports = with inputs.self.modules.nixos; with inputs.self.factory; [
      nixos_minimal
      default-graphics
      home-manager
      nur
      fonts
      (greetd-nixos "niri-session")
      kdeconnect
      yubikey-desktop
      syncthing
    ];
  };
}
