{pkgs, ...}:
{
  imports = [];
  
  options = {};

  config = {
    home.file.".config/kitty/kitty.conf" = {
      source = ./kitty.conf;
      recursive = true;
    };

    home.packages = with pkgs; [
      kitty
    ];
  };
}
