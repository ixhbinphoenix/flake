{ inputs, ... }: {
  flake-file.inputs = {
    niri.url = "https://git.ixhby.dev/mirrors/niri-flake/archive/main.tar.gz";
    niri.inputs.nixpkgs.follows = "nixpkgs";
  };

  flake.modules.nixos.niri = {
    imports = [
      inputs.niri.nixosModules.niri
    ];
  };

  flake.modules.homeManager.niri = {
    imports = [
      inputs.niri.homeModules.niri
    ];
  };
}
