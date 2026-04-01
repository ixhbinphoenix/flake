{ inputs, ...}: {
  flake-file.inputs = {
    nur.url = "https://git.ixhby.dev/mirrors/NUR/archive/master.tar.gz";
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
