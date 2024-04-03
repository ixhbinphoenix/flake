{ lib, config, pkgs, ...}:
{
  imports = [];
  options = {};

  config = {
    home.file.".config/waybar/config" = {
      source = ./config;
      recursive = true;
    };
    home.file.".config/waybar/style.css" = {
      source = ./style.css;
      recursive = true;
    };

    home.packages = with pkgs; [
      waybar
    ];
  };
}
