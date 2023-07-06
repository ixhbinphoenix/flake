{pkgs, ...}:
{
  home.file.".local/bin/scripts" = {
    source = ./scripts;
    recursive = true;
  };
}
