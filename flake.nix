{
  description = "ixhbinphoenix's NixOS Configuration flake";

  nixConfig = {
    extra-substituters = [ "https://nix-community.cachix.org" "https://nixerus.cachix.org" "https://hyprland.cachix.org" "https://ixhbinphoenix.cachix.org" "https://ezkea.cachix.org" ];
    extra-trusted-public-keys = [ "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" "nixerus.cachix.org-1:2x7sIG7y1vAoxc8BNRJwsfapZsiX4hIl4aTi9V5ZDdE=" "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" "ixhbinphoenix.cachix.org-1:rsJblC+rFjboYwlCknX+mj/BRM66U2X8ArAuqlCpQFc=" "ezkea.cachix.org-1:ioBmUbJTZIKsHmWWXPe1FSFbeVe+afhfgqgTSNd34eI=" ];
  };

  inputs = {
    # package repos
    nixpkgs.url = "https://git.ixhby.dev/mirrors/nixpkgs/archive/nixos-unstable.tar.gz"; # github:nixos/nixpkgs
    home-manager.url = "https://git.ixhby.dev/mirrors/home-manager/archive/master.tar.gz"; # github:nix-community/home-manager
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nur.url = "https://git.ixhby.dev/mirrors/NUR/archive/main.tar.gz"; # github:nix-community/NUR

    # foundational
    lix-module.url = "https://git.ixhby.dev/mirrors/lixos-module/archive/main.tar.gz"; # git.lix.systems/lix-project/nixos-module
    lix-module.inputs.nixpkgs.follows = "nixpkgs";
    nixos-hardware.url = "https://git.ixhby.dev/mirrors/nixos-hardware/archive/master.tar.gz"; # github:nixos/nixos-hardware
    sops-nix.url = "https://git.ixhby.dev/mirrors/sops-nix/archive/master.tar.gz"; # github:Mic92/sops-nix
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    # speific packages
    nixvim.url = "https://git.ixhby.dev/mirrors/nixvim/archive/main.tar.gz"; # github:nix-community/nixvim
    aagl.url = "https://git.ixhby.dev/mirrors/aagl-gtk-on-nix/archive/main.tar.gz"; # github:ezKEa/aagl-gtk-on-nix
    aagl.inputs.nixpkgs.follows = "nixpkgs";
    anyrun.url = "https://git.ixhby.dev/mirrors/anyrun/archive/master.tar.gz"; # github:anyrun-org/anyrun
    anyrun.inputs.nixpkgs.follows = "nixpkgs";
    deploy-rs.url = "https://git.ixhby.dev/mirrors/deploy-rs/archive/master.tar.gz"; # github:serokell/deploy-rs
    deploy-rs.inputs.nixpkgs.follows = "nixpkgs";
    anyrun-nixos-options.url = "github:n3oney/anyrun-nixos-options";
    anyrun-nixos-options.inputs.nixpkgs.follows = "nixpkgs";
    niri.url = "https://git.ixhby.dev/mirrors/niri-flake/archive/main.tar.gz"; # github:sodiboo/niri-flake
    niri.inputs.nixpkgs.follows = "nixpkgs";
    usc.url = "https://git.ixhby.dev/ixhbinphoenix/usc-flake/archive/root.tar.gz";
    usc.inputs.nixpkgs.follows = "nixpkgs";

    # misc modules
    catppuccin.url = "https://git.ixhby.dev/mirrors/catppuccin-nix/archive/main.tar.gz"; # github:catppuccin/nix

    # testament
    garnix-dev.url = "https://git.ixhby.dev/ixhbinphoenix/garnix.dev/archive/master.tar.gz";
    garnix-dev.inputs.nixpkgs.follows = "nixpkgs";
    clock-lantern.url = "https://git.ixhby.dev/ixhbinphoenix/clock-o-lantern/archive/root.tar.gz";
    clock-lantern.inputs.nixpkgs.follows = "nixpkgs";
    gleachring.url = "https://git.ixhby.dev/ixhbinphoenix/gleachring/archive/root.tar.gz";
    gleachring.inputs.nixpkgs.follows = "nixpkgs";

  };

  outputs = inputs @ { self, nixpkgs, deploy-rs, ... }:
    let
      user = "phoenix";
    in {
      nixosConfigurations = (
        import ./hosts {
          inherit (nixpkgs) lib;
          inherit inputs nixpkgs user;
        }
      );

      deploy.nodes.lucy = {
        hostname = "lucy";
        profiles.system = {
          path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.lucy;
          sshUser = "root";
          user = "root";
          autoRollback = true;
          magicRollback = true;
          activationTimeout = 600;
          confirmTimeout = 60;
        };
      };

      deploy.nodes.ino = {
        hostname = "ino";
        profiles.system = {
          path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.ino;
          sshUser = "root";
          user = "root";
          autoRollback = true;
          magicRollback = true;
          activationTimeout = 600;
          confirmTimeout = 60;
        };
      };

      deploy.nodes.testament = {
        hostname = "testament";
        profiles.system = {
          path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.testament;
          sshUser = "root";
          user = "root";
          autoRollback = true;
          magicRollback = true;
          activationTimeout = 600;
          confirmTimeout = 60;
        };
      };
    };
}
