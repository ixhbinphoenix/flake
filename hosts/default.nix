{nixpkgs, lib, inputs, user, home-manager, nur, nixvim, hyprland, aagl, anyrun, anyrun-nixos-options, arrpc, deploy-rs, niri, catppuccin, nixos-hardware, ...}:
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
      #hyprland.nixosModules.default
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = { inherit user anyrun anyrun-nixos-options home-manager; };
        home-manager.users.${user} = {
          imports = [
            nixvim.homeManagerModules.nixvim
            hyprland.homeManagerModules.default
            anyrun.homeManagerModules.default
            niri.homeModules.niri
            catppuccin.homeManagerModules.catppuccin
            ./snowflake/home.nix
            ../stages/pc-base/home.nix
            ../stages/wayland/home.nix
          ];
        };
      }
      {
        imports = [ aagl.nixosModules.default ];
        nix.settings = aagl.nixConfig;
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
            #hyprland.homeManagerModules.default
            anyrun.homeManagerModules.default
            niri.homeModules.niri
            catppuccin.homeManagerModules.catppuccin
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
  ramlethal = lib.nixosSystem {
    inherit system;
    specialArgs = { inherit user inputs nur deploy-rs; };
    modules = [
      nixos-hardware.nixosModules.framework-16-7040-amd
      nur.nixosModules.nur
      ./ramlethal
      ../stages/pc-base
      ../stages/wayland
      home-manager.nixosModules.home-manager {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = { inherit user anyrun anyrun-nixos-options home-manager; };
        home-manager.users.${user} = {
          imports = [
            nixvim.homeManagerModules.nixvim
            anyrun.homeManagerModules.default
            niri.homeModules.niri
            catppuccin.homeManagerModules.catppuccin
            ./ramlethal/home.nix
            ../stages/pc-base/home.nix
            ../stages/wayland/home.nix
          ];
        };
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
            catppuccin.homeManagerModules.catppuccin
            ./twinkpad/home.nix
            ../stages/pc-base/home.nix
          ];
        };
      }
    ];
  };
}
