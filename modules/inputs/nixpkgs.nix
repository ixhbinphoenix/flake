{ inputs, ... } : {
  flake-file.inputs = {
    nixpkgs.url = "https://git.ixhby.dev/mirrors/nixpkgs/archive/nixpkgs-unstable.tar.gz";
    nixpkgs-lib.follows = "nixpkgs";

    systems.url = "https://git.ixhby.dev/mirrors/nix-systems/archive/main.tar.gz";
  };

  systems = import inputs.systems;
}
