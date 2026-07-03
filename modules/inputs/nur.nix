{ inputs, ...}: {
  flake-file.inputs = {
    nur.url = "https://git.ixhby.dev/mirrors/NUR/archive/master.tar.gz";
    #nur.url = "github:nix-community/NUR";
  };

  flake.modules.nixos.nur = {
    imports = [
      inputs.nur.modules.nixos.default
    ];
  };

  flake.modules.homeManager.nur = {
    imports = [
      inputs.nur.modules.homeManager.default
    ];
  };
}
