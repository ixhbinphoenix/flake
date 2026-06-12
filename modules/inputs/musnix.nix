{ inputs, ... }: {
  flake-file.inputs = {
    musnix.url = "github:musnix/musnix";
    musnix.inputs.nixpkgs.follows = "nixpkgs";
  };

  flake.modules.nixos.musnix = {
    imports = [
      inputs.musnix.nixosModules.musnix
    ];
  };
}
