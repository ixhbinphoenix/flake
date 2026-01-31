{ inputs, ... }: {
  imports = [
    inputs.flake-file.flakeModules.default
    inputs.flake-file.flakeModules.import-tree
    (inputs.flake-parts.flakeModules.modules or { })
  ];

  flake-file.inputs = {
    flake-file.url = "https://git.ixhby.dev/mirrors/flake-file/archive/main.tar.gz";
    flake-parts.url = "https://git.ixhby.dev/mirrors/flake-parts/archive/main.tar.gz";
    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs-lib";
  };

  flake-file.outputs = ''
    inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./modules)
  '';

  flake.modules = { };
}
