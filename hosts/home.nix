{ config, pkgs, lib, user, ...}:
{
  imports = [
    ../scripts.nix
    ../modules/shell/zsh
    ../modules/desktop/wlogout.nix
    ../modules/desktop/anyrun.nix
    ../modules/programs/bat.nix
    ../modules/programs/git.nix
    ../modules/programs/tmux.nix
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
    ffmpeg
    mpv
    youtube-tui
    p7zip
    mediainfo
    prismlauncher
    chatterino2
    tenacity
    websocat
    yubikey-manager
    yubikey-manager-qt
    yubikey-personalization
    yubikey-personalization-gui
    yubico-piv-tool
    yubioath-flutter
    wine-staging
    winetricks
    protontricks
    gpodder
    nyxt
    nur.repos.ixhbinphoenix.todoit
    php
    miniserve
    transmission-qt
    trackma-qt
    vesktop
    strawberry
    nheko
  ];

  services.syncthing.enable = true;

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  home.pointerCursor = {
    gtk.enable = true;
    name = "Catppuccin-Mocha-Mauve";
    size = 48;
    package = pkgs.catppuccin-cursors.mochaMauve;
  };

  gtk = {
    enable = true;
    theme = {
      name = "Catppuccin-Mocha-Compact-Mauve-dark";
      package = pkgs.catppuccin-gtk.override {
        accents = [ "mauve" ];
        size = "compact";
        tweaks = [ "rimless" "black" ];
        variant = "mocha";
      };
    };
  };
}
