{ config, pkgs, lib, user, ...}:
{
  imports = [
    ../scripts.nix
    ../modules/shell/zsh
    ../modules/desktop/wlogout.nix
    ../modules/programs/bat.nix
    ../modules/programs/git.nix
    ../modules/programs/tmux.nix
    ../modules/programs/syncthing.nix
    ../modules/programs/nixvim.nix
    ../modules/programs/kitty
  ];
  home.username = "${user}";
  home.homeDirectory = "/home/${user}";
  
  home.stateVersion = "23.11";

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    kitty
    lsd
    nixd
    lua-language-server
    pavucontrol
    keepassxc
    xdg-utils
    neofetch
    btop
    onefetch
    ani-cli
    yt-dlp
    trackma-gtk
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  home.pointerCursor = {
    gtk.enable = true;
    name = "Catppuccin-Mocha-Sky";
    size = 48;
    package = pkgs.catppuccin-cursors.mochaSky;
  };

  gtk = {
    enable = true;
    theme = {
      name = "Catppuccin-Mocha-Compact-Sky-dark";
      package = pkgs.catppuccin-gtk.override {
        accents = [ "sky" ];
        size = "compact";
        tweaks = [ "rimless" "black" ];
        variant = "mocha";
      };
    };
  };
}
