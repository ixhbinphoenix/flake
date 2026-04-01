{ self, inputs, ... }: {
  flake-file.inputs = {
    home-manager.url = "https://git.ixhby.dev/mirrors/home-manager/archive/master.tar.gz";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };
  
  imports = [ inputs.home-manager.flakeModules.home-manager ];

  flake.modules.nixos.home-manager = {
    imports = [
      inputs.home-manager.nixosModules.home-manager
    ];

    environment.pathsToLink = [ "/share/applications" "/share/xdg-desktop-portal" ];

    home-manager = {
      verbose = true;
      useUserPackages = true;
      useGlobalPkgs = true;
    };
  };
}
