{nixpkgs, lib, inputs, user, home-manager, ...}:
let
  system = "x86_64-linux";

  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true;
  };
in
{
  qemu-nix = lib.nixosSystem {
    inherit system;
    specialArgs = { inherit user inputs; };
    modules = [
      ./qemu-nix
      ./configuration.nix
      home-manager.nixosModules.home-manager {
        home-manager.useGlobalPkgs = true;
	      home-manager.useUserPackages = true;
      	home-manager.extraSpecialArgs = { inherit user; };
      	home-manager.users.${user} = {
      	  imports = [
            ./home.nix 
            ./qemu-nix/home.nix 
          ];
        };
      }
    ];
  };
}
