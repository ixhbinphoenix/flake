{ pkgs, ... }:
{
  config = {
    # TODOO: Replace this with actual packages, e.g. through writeShellApplication
    home.file.".local/bin/scripts" = {
      source = ./scripts;
      recursive = true;
    };

    home.packages = with pkgs; [
      grim
      slurp
    ];
  };
}
