{ inputs, ... }: {
  flake-file.inputs = {
    lix.url = "https://git.ixhby.dev/mirrors/lix/archive/main.tar.gz";
    lix.flake = false;
    lix-module.url = "https://git.ixhby.dev/mirrors/lixos-module/archive/main.tar.gz";
    lix-module.inputs.nixpkgs.follows = "nixpkgs";
    lix-module.inputs.lix.follows = "lix";
  };

  flake.modules.nixos.lix = {
    imports = [
      inputs.lix-module.nixosModules.default
    ];
  };
}
