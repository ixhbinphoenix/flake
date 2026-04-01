{ inputs, ... }: {
  flake-file.inputs = {
    catppuccin.url = "https://git.ixhby.dev/mirrors/catppuccin-nix/archive/main.tar.gz";
  };

  flake.modules.nixos.catppuccin = {
    imports = [
      inputs.catppuccin.nixosModules.catppuccin
    ];
  };

  flake.modules.homeManager.catppuccin = {
    imports = [
      inputs.catppuccin.homeModules.catppuccin
    ];

    catppuccin = {
      enable = true;
      accent = "mauve";
      flavor = "mocha";

      cursors = {
        enable = true;
        accent = "dark";
      };
    };

    programs.niri.settings.cursor.theme = "catppuccin-mocha-dark-cursors";
  };
}
