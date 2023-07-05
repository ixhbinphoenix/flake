{ config, pkgs, lib, user, ... }:

{
  imports = [
    ../../modules/desktop/sway
    ../../modules/programs/kitty
    ../../modules/programs/waybar
    ../../modules/shell/zsh
    ../../modules/programs/git
    ../../modules/programs/dunst
    ../../modules/programs/tmux
    ../../modules/programs/nvim
  ];
  home.username = "${user}";
  home.homeDirectory = "/home/${user}";
  
  home.stateVersion = "23.11";

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    librewolf
    waybar
    kitty
    swww
    lsd
    bat
    flameshot
    iosevka
    source-code-pro
    weston
  ];

  programs.librewolf = {
    enable = true;    
  };
}
