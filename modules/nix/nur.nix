{ inputs, ...}: {
  flake-file.inputs = {
    nur.url = "https://git.ixhby.dev/mirrors/NUR/archive/master.tar.gz";
  };

  flake.modules.nixos.nur = {
    imports = [
      inputs.nur.nixosModules.default
    ];
  };

  flake.modules.home-manager.nur = {
    imports = [
      inputs.nur.homeModules.default
    ];
  };
}
