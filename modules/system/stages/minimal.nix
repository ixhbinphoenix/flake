{ inputs, ... }: {
  flake.modules.nixos.nixos_minimal = {
    imports = with inputs.self.modules.nixos; [
      nix-config
      localization
      doas
      shell
    ];
  };
}
