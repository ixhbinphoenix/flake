{
  description = "ixhbinphoenix's NixOS Configuration flake";

  nixConfig = {
    extra-substituters = [ "https://nix-community.cachix.org" "https://nixerus.cachix.org" "https://hyprland.cachix.org" "https://ixhbinphoenix.cachix.org" "https://ezkea.cachix.org" ];
    extra-trusted-public-keys = [ "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" "nixerus.cachix.org-1:2x7sIG7y1vAoxc8BNRJwsfapZsiX4hIl4aTi9V5ZDdE=" "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" "ixhbinphoenix.cachix.org-1:rsJblC+rFjboYwlCknX+mj/BRM66U2X8ArAuqlCpQFc=" "ezkea.cachix.org-1:ioBmUbJTZIKsHmWWXPe1FSFbeVe+afhfgqgTSNd34eI=" ];
  };

  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/nixos-unstable;
    home-manager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur.url = github:nix-community/NUR;
    nixvim = {
      url = github:nix-community/nixvim;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    aagl = {
      url = github:ezKEa/aagl-gtk-on-nix;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = github:hyprwm/Hyprland;
    anyrun = {
      url = github:Kirottu/anyrun;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    arrpc = {
      url = github:NotAShelf/arrpc-flake;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    deploy-rs.url = github:serokell/deploy-rs;
  };

  outputs = inputs @ { self, nixpkgs, home-manager, nur, nixvim, hyprland, aagl, anyrun, arrpc, deploy-rs }:
    let
      user = "phoenix";
    in rec {
      nixosConfigurations = (
        import ./hosts {
          inherit (nixpkgs) lib;
          inherit inputs nixpkgs user home-manager nur nixvim hyprland aagl anyrun arrpc deploy-rs;
        }
      );
      
      deploy.nodes.twinkpad = {
        hostname =  "twinkpad";
        profiles.system = {
          path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.twinkpad;
          sshUser = "phoenix";
          user = "root";
          sudo = "doas -u ";
          autoRollback = true;
          magicRollback = true;
          activationTimeout = 600;
          confirmTimeout = 60;
        };
      };
    };
}
