{pkgs, ...}:
{
  home.file.".config/waybar/config" = {
    source = ./config;
    recursive = true;
  };
  home.file.".config/waybar/style.css" = {
    source = ./style.css;
    recursive = true;
  };
}
