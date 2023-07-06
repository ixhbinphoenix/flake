{ config, pkgs, lib, user, ... }:

{
  imports = [
    ../../modules/desktop/sway
    ../../modules/programs/waybar
  ];

  home.packages = with pkgs; [
    waybar
    swww
    flameshot
  ];

  programs.librewolf = {
    enable = true;    
  };
}
