# DO-NOT-EDIT. This file was auto-generated using github:vic/flake-file.
# Use `nix run .#write-flake` to regenerate it.
{
  description = "ixhby's monoflake";

  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./modules);

  inputs = {
    catppuccin.url = "https://git.ixhby.dev/mirrors/catppuccin-nix/archive/main.tar.gz";
    flake-file.url = "https://git.ixhby.dev/mirrors/flake-file/archive/main.tar.gz";
    flake-parts = {
      inputs.nixpkgs-lib.follows = "nixpkgs-lib";
      url = "https://git.ixhby.dev/mirrors/flake-parts/archive/main.tar.gz";
    };
    home-manager = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "https://git.ixhby.dev/mirrors/home-manager/archive/master.tar.gz";
    };
    import-tree.url = "github:vic/import-tree";
    niri = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "https://git.ixhby.dev/mirrors/niri-flake/archive/main.tar.gz";
    };
    nixpkgs.url = "https://git.ixhby.dev/mirrors/nixpkgs/archive/nixpkgs-unstable.tar.gz";
    nixpkgs-lib.follows = "nixpkgs";
    nixvim.url = "https://git.ixhby.dev/mirrors/nixvim/archive/main.tar.gz";
    nur.url = "https://git.ixhby.dev/mirrors/NUR/archive/master.tar.gz";
    systems.url = "https://git.ixhby.dev/mirrors/nix-systems/archive/main.tar.gz";
  };

}
