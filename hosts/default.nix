{nixpkgs, lib, inputs, user, home-manager, nur, nixvim, aagl, anyrun, anyrun-nixos-options, arrpc, deploy-rs, niri, catppuccin, nixos-hardware, sops-nix, conduwuit, quadlet-nix, garnix-dev, usc, clock-lantern, ...}:
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
      sops-nix.nixosModules.sops
      nur.modules.nixos.default
      ./snowflake
      ../stages/pc-base
      ../stages/wayland
      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = { inherit user anyrun anyrun-nixos-options home-manager usc; };
        home-manager.users.${user} = {
          imports = [
            nixvim.homeManagerModules.nixvim
            anyrun.homeManagerModules.default
            niri.homeModules.niri
            catppuccin.homeManagerModules.catppuccin
            sops-nix.homeManagerModules.sops
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
      sops-nix.nixosModules.sops
      nur.modules.nixos.default
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
            anyrun.homeManagerModules.default
            niri.homeModules.niri
            catppuccin.homeManagerModules.catppuccin
            sops-nix.homeManagerModules.sops
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
      sops-nix.nixosModules.sops
      nur.modules.nixos.default
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
            sops-nix.homeManagerModules.sops
            ./ramlethal/home.nix
            ../stages/pc-base/home.nix
            ../stages/wayland/home.nix
          ];
        };
      }
    ];
  };
  testament = lib.nixosSystem {
    inherit system;
    specialArgs = { inherit user inputs nur deploy-rs conduwuit garnix-dev; };
    modules = [
      sops-nix.nixosModules.sops
      quadlet-nix.nixosModules.quadlet
      clock-lantern.nixosModules.${system}.default
      ./testament
    ];
  };
  twinkpad = lib.nixosSystem {
    inherit system;
    specialArgs = { inherit user inputs nur; };
    modules = [
      nur.modules.nixos.default
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
