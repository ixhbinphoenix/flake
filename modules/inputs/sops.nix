{ inputs, ... }: {
  flake-file.inputs = {
    sops-nix.url = "https://git.ixhby.dev/mirrors/sops-nix/archive/master.tar.gz";
    #sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  flake.modules.nixos.sops = {
    imports = [
      inputs.sops-nix.nixosModules.sops
      {
        sops.defaultSopsFile = ../../secrets/default.yaml;
      }
    ];
  };

  flake.modules.homeManager.sops = {
    imports = [
      inputs.sops-nix.homeManagerModules.sops
      {
        sops.defaultSopsFile = ../../secrets/default.yaml;
      }
    ];
  };
}
