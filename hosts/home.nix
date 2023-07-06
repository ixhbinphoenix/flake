{ config, pkgs, lib, user, ...}:
{
  imports = [
    ../modules/shell/zsh
    ../modules/programs/bat
    ../modules/programs/git
    ../modules/programs/tmux
    ../modules/programs/nvim
    ../modules/programs/kitty
  ];
  home.username = "${user}";
  home.homeDirectory = "/home/${user}";
  
  home.stateVersion = "23.11";

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    kitty
    lsd
  ];
}
