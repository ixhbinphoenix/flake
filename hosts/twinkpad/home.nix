{ config, pkgs, user, ... }:
{
  imports = [];
  
  stages.pc-base = {
    enable = true;
    user = user;
  };

  home.stateVersion = "23.11";

  home.packages = with pkgs; [
  ];
}
