{nixpkgs, lib, inputs, user, home-manager, nur, nixvim, hyprland, aagl, anyrun, anyrun-nixos-options, arrpc, deploy-rs, ...}:
let
  system = "x86_64-linux";

  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true;
  };
in
{
  snowflake = lib.nixosSystem {
    inherit system;
    specialArgs = { inherit user inputs nur deploy-rs; };
    modules = [
      nur.nixosModules.nur
      ./snowflake
      ./configuration.nix
      home-manager.nixosModules.home-manager {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = { inherit user anyrun anyrun-nixos-options home-manager; };
        home-manager.users.${user} = {
          imports = [
            nixvim.homeManagerModules.nixvim
            hyprland.homeManagerModules.default
            anyrun.homeManagerModules.default
            ./home.nix
            ./snowflake/home.nix
          ];
        };
      }
      {
        imports = [ aagl.nixosModules.default ];
        nix.settings = aagl.nixConfig;
        programs.anime-games-launcher.enable = true;
        programs.anime-game-launcher.enable = true;
      }
    ];
  };
  unique = lib.nixosSystem {
    inherit system;
    specialArgs = { inherit user inputs nur deploy-rs; };
    modules = [
      nur.nixosModules.nur
      ./unique
      ./configuration.nix
      home-manager.nixosModules.home-manager {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = { inherit user anyrun anyrun-nixos-options home-manager; };
        home-manager.users.${user} = {
          imports = [
            nixvim.homeManagerModules.nixvim
            hyprland.homeManagerModules.default
            anyrun.homeManagerModules.default
            ./home.nix
            ./unique/home.nix
          ];
        };
      }
      {
        imports = [ aagl.nixosModules.default ];
        nix.settings = aagl.nixConfig;
        programs.anime-game-launcher.enable = true;
      }
    ];
  };
  twinkpad = lib.nixosSystem {
    inherit system;
    specialArgs = { inherit user inputs nur; };
    modules = [
      nur.nixosModules.nur
      ./twinkpad
      home-manager.nixosModules.home-manager {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = { inherit user anyrun anyrun-nixos-options; };
        home-manager.users.${user} = {
          imports = [
            nixvim.homeManagerModules.nixvim
            anyrun.homeManagerModules.default
            ./twinkpad/home.nix
          ];
        };
      }
    ];
  };
}
