{ inputs, ... }: {
  flake.modules.nixos.nixos_minimal = { pkgs, ... }: {
    imports = with inputs.self.modules.nixos; [
      nix-config
      lix
      localization
      doas
      shell
      sops
    ];

    environment.systemPackages = with pkgs; [
      git
    ];
  };
}
