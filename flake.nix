{
  description = "ixhbinphoenix's NixOS Configuration flake";

  nixConfig = {
    extra-substituters = [ "https://nix-community.cachix.org" "https://nixerus.cachix.org" "https://hyprland.cachix.org" "https://ixhbinphoenix.cachix.org" "https://ezkea.cachix.org" "https://attic.kennel.juneis.dog/conduwuit" ];
    extra-trusted-public-keys = [ "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" "nixerus.cachix.org-1:2x7sIG7y1vAoxc8BNRJwsfapZsiX4hIl4aTi9V5ZDdE=" "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" "ixhbinphoenix.cachix.org-1:rsJblC+rFjboYwlCknX+mj/BRM66U2X8ArAuqlCpQFc=" "ezkea.cachix.org-1:ioBmUbJTZIKsHmWWXPe1FSFbeVe+afhfgqgTSNd34eI=" "conduwuit:BbycGUgTISsltcmH0qNjFR9dbrQNYgdIAcmViSGoVTE=" ];
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
    anyrun = {
      url = github:Kirottu/anyrun;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    arrpc = {
      url = github:NotAShelf/arrpc-flake;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    deploy-rs = {
      url = github:serokell/deploy-rs;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    anyrun-nixos-options = {
      url = github:n3oney/anyrun-nixos-options;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri.url = github:sodiboo/niri-flake;
    niri.inputs.nixpkgs.follows = "nixpkgs";
    catppuccin.url = github:catppuccin/nix;
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    sops-nix.url = github:Mic92/sops-nix;
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    conduwuit.url = "https://git.gay/june/conduwuit/archive/main.tar.gz";
    conduwuit.inputs.nixpkgs.follows = "nixpkgs";
    conduwuit.inputs.rocksdb = {
      url = "github:girlbossceo/rocksdb?ref=v9.7.3";
      flake = false;
    };

    quadlet-nix.url = github:SEIAROTg/quadlet-nix;
    quadlet-nix.inputs.nixpkgs.follows = "nixpkgs";

    garnix-dev.url = "https://git.ixhby.dev/ixhbinphoenix/garnix.dev/archive/master.tar.gz";
    garnix-dev.inputs.nixpkgs.follows = "nixpkgs";

    usc.url = "https://git.ixhby.dev/ixhbinphoenix/usc-flake/archive/root.tar.gz";
    usc.inputs.nixpkgs.follows = "nixpkgs";

    clock-lantern.url = "https://git.ixhby.dev/ixhbinphoenix/clock-o-lantern/archive/root.tar.gz";
    clock-lantern.inputs.nixpkgs.follows = "nixpkgs";
    gleachring.url = "https://git.ixhby.dev/ixhbinphoenix/gleachring/archive/root.tar.gz";
    gleachring.inputs.nixpkgs.follows = "nixpkgs";

    pr-370878-zipline.url = github:Defelo/nixpkgs/zipline;
  };

  outputs = inputs @ { self, nixpkgs, home-manager, nur, nixvim, aagl, anyrun, anyrun-nixos-options, arrpc, deploy-rs, niri, catppuccin, nixos-hardware, sops-nix, conduwuit, quadlet-nix, garnix-dev, usc, clock-lantern, gleachring, pr-370878-zipline }:
    let
      user = "phoenix";
    in rec {
      nixosConfigurations = (
        import ./hosts {
          inherit (nixpkgs) lib;
          inherit inputs nixpkgs user home-manager nur nixvim aagl anyrun anyrun-nixos-options arrpc deploy-rs niri catppuccin nixos-hardware sops-nix conduwuit quadlet-nix garnix-dev usc clock-lantern gleachring;
        }
      );

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
