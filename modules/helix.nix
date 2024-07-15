{ config, pkgs, lib, ...}:
{
  imports = [];

  options = {};

  config = {
    programs.helix = {
      enable = true;
    };
  };
}
