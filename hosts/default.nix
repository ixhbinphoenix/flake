{nixpkgs, lib, inputs, user, home-manager, nur, nixvim, ...}:
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
      nur.nixosModules.nur
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
  snowflake = lib.nixosSystem {
    inherit system;
    specialArgs = { inherit user inputs; };
    modules = [
      nur.nixosModules.nur
      ./snowflake
      ./configuration.nix
      home-manager.nixosModules.home-manager {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = { inherit user; };
        home-manager.users.${user} = {
          imports = [
            nixvim.homeManagerModules.nixvim
            ./home.nix
            ./snowflake/home.nix
          ];
        };
      }
    ];
  };
}
