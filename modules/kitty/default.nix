{pkgs, ...}:
{
  home.file.".config/kitty/kitty.conf" = {
    source = ./kitty.conf;
    recursive = true;
  };
}
