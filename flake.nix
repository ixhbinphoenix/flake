{
  description = "ixhbinphoenix's NixOS Configuration flake";

  nixConfig = {
    extra-substituters = [ "https://nix-community.cachix.org" "https://nixerus.cachix.org" "https://hyprland.cachix.org" ];
    extra-trusted-public-keys = [ "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" "nixerus.cachix.org-1:2x7sIG7y1vAoxc8BNRJwsfapZsiX4hIl4aTi9V5ZDdE=" "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
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
    hyprland.url = github:hyprwm/Hyprland;
  };

  outputs = inputs @ { self, nixpkgs, home-manager, nur, nixvim, hyprland }:
    let
      user = "phoenix";
    in {
      nixosConfigurations = (
        import ./hosts {
          inherit (nixpkgs) lib;
          inherit inputs nixpkgs user home-manager nur nixvim hyprland;
        }
      );
    };
}
