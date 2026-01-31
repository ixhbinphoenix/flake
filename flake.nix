# DO-NOT-EDIT. This file was auto-generated using github:vic/flake-file.
# Use `nix run .#write-flake` to regenerate it.
{
  description = "ixhby's monoflake";

  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./modules);

  inputs = {
    flake-file.url = "https://git.ixhby.dev/mirrors/flake-file/archive/main.tar.gz";
    flake-parts = {
      inputs.nixpkgs-lib.follows = "nixpkgs-lib";
      url = "https://git.ixhby.dev/mirrors/flake-parts/archive/main.tar.gz";
    };
    import-tree.url = "github:vic/import-tree";
    nixpkgs.url = "https://git.ixhby.dev/mirrors/nixpkgs/archive/nixpkgs-unstable.tar.gz";
    nixpkgs-lib.follows = "nixpkgs";
    systems.url = "https://git.ixhby.dev/mirros/nix-systems/archive/main.tar.gz";
  };

}
