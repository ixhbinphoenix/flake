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
      ../stages/pc-base
      ../stages/wayland
      home-manager.nixosModules.home-manager
      hyprland.nixosModules.default
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = { inherit user anyrun anyrun-nixos-options home-manager; };
        home-manager.users.${user} = {
          imports = [
            nixvim.homeManagerModules.nixvim
            hyprland.homeManagerModules.default
            anyrun.homeManagerModules.default
            ./snowflake/home.nix
            ../stages/pc-base/home.nix
            ../stages/wayland/home.nix
          ];
        };
      }
      {
        imports = [ aagl.nixosModules.default ];
        nix.settings = aagl.nixConfig;
        programs.sleepy-launcher.enable = true;
        programs.honkers-railway-launcher.enable = true;
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
      ../stages/pc-base
      ../stages/wayland
      home-manager.nixosModules.home-manager {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = { inherit user anyrun anyrun-nixos-options home-manager; };
        home-manager.users.${user} = {
          imports = [
            nixvim.homeManagerModules.nixvim
            hyprland.homeManagerModules.default
            anyrun.homeManagerModules.default
            ./unique/home.nix
            ../stages/pc-base/home.nix
            ../stages/wayland/home.nix
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
      ../stages/pc-base
      home-manager.nixosModules.home-manager {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = { inherit user anyrun anyrun-nixos-options; };
        home-manager.users.${user} = {
          imports = [
            nixvim.homeManagerModules.nixvim
            anyrun.homeManagerModules.default
            ./twinkpad/home.nix
            ../stages/pc-base/home.nix
          ];
        };
      }
    ];
  };
}
