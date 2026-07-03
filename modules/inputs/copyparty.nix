{ inputs, ... }: {
  flake-file.inputs = {
    copyparty.url = "https://git.ixhby.dev/mirrors/copyparty/archive/hovudstraum.tar.gz";
    #copyparty.url = "github:9001/copyparty";
    copyparty.inputs.nixpkgs.follows = "nixpkgs";
  };

  flake.modules.nixos.copyparty = {
    imports = [
      inputs.copyparty.nixosModules.default
    ];
  };
}
