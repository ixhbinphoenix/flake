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
      inputs.catppuccin.nixosModules.catppuccin
      ./${hostname}/default.nix
    ] ++ additionalModules;
  };

  mkServerSystem = {hostname, additionalModules ? []}: mkSystem {
    inherit hostname;
    additionalModules = [
      ../stages/server
      {
        stages.server.hostname = hostname;
      }
      ../modules/server
    ] ++ additionalModules;
  };

  mkHomeSystem = {hostname, additionalModules ? [], additionalHomeModules ? []}: mkSystem {
    inherit hostname;
    additionalModules = [
      ../stages/pc-base
      {
        stages.pc-base.hostname = hostname;
      }
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
  dizzy = lib.nixosSystem (mkHomeSystem {
    hostname = "dizzy";
  });
  ramlethal = lib.nixosSystem (mkHomeSystem {
    hostname = "ramlethal";
    additionalModules = [
      inputs.nixos-hardware.nixosModules.framework-16-7040-amd
    ];
  });
  lucy = lib.nixosSystem(mkServerSystem {
    hostname = "lucy";
    additionalModules = [
      inputs.catppuccin.nixosModules.default
      inputs.gleachring.nixosModules.${pkgs.stdenv.hostPlatform.system}.default
      inputs.nix-minecraft.nixosModules.minecraft-servers
      inputs.copyparty.nixosModules.default
    ];
  });
  ino = lib.nixosSystem(mkServerSystem {
    hostname = "ino";
  });
  axl = lib.nixosSystem {
    specialArgs = { inherit user inputs; };
    modules = [
      inputs.sops-nix.nixosModules.sops
      inputs.catppuccin.nixosModules.catppuccin
      ./axl/default.nix
      ../stages/server
      {
        stages.server.hostname = "axl";
      }
      ../modules/server
    ];
  };
}
