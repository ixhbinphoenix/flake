{ inputs, ... }: {
  flake-file.inputs = {
    nixocaine.url = "https://git.ixhby.dev/mirrors/nixocaine/archive/main.tar.gz";
    nixocaine.inputs.nixpkgs.follows = "nixpkgs";
  };

  flake.modules.nixos.iocaine = {
    imports = [ inputs.nixocaine.nixosModules.default ];
  };
}
