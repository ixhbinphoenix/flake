{nixpkgs, lib, inputs, user, ...}:
let
  pkgs = import nixpkgs {
    system = "x86_64-linux";
    config.allowUnfree = true;
  };

  mkSystem = {hostname, additionalModules ? []}: {
    specialArgs = { inherit user inputs; };
    modules = [
      inputs.lix-module.nixosModules.default
      inputs.sops-nix.nixosModules.sops
      ./${hostname}/default.nix
    ] ++ additionalModules;
  };

  mkHomeSystem = {hostname, additionalModules ? [], additionalHomeModules ? []}: mkSystem {
    inherit hostname;
    additionalModules = [
      ../stages/pc-base
      ../stages/wayland
      inputs.home-manager.nixosModules.home-manager
      inputs.aagl.nixosModules.default
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = { inherit user inputs; };
        home-manager.users.${user} = {
          imports = [
            inputs.nixvim.homeModules.nixvim
            inputs.niri.homeModules.niri
            inputs.catppuccin.homeModules.catppuccin
            inputs.sops-nix.homeManagerModules.sops
            ./${hostname}/home.nix
            ../stages/pc-base/home.nix
            ../stages/wayland/home.nix
          ] ++ additionalHomeModules;
        };
      }
    ] ++ additionalModules;
  };
in
{
  snowflake = lib.nixosSystem (mkHomeSystem {
    hostname = "snowflake";
  });
  ramlethal = lib.nixosSystem (mkHomeSystem {
    hostname = "ramlethal";
    additionalModules = [
      inputs.nixos-hardware.nixosModules.framework-16-7040-amd
    ];
  });
  testament = lib.nixosSystem(mkSystem {
    hostname = "testament";
    additionalModules = [
      inputs.clock-lantern.nixosModules.${pkgs.system}.default
      inputs.gleachring.nixosModules.${pkgs.system}.default
    ];
  });
  lucy = lib.nixosSystem(mkSystem {
    hostname = "lucy";
  });
  ino = lib.nixosSystem(mkSystem {
    hostname = "ino";
  });
}
