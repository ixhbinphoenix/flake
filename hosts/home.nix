{ config, pkgs, lib, user, ...}:
{
  imports = [
    ../scripts.nix
    ../modules/zsh
    ../modules/wlogout.nix
    ../modules/anyrun.nix
    ../modules/bat.nix
    ../modules/git.nix
    ../modules/tmux.nix
    ../modules/nixvim.nix
    ../modules/kitty
  ];
  home.username = "${user}";
  home.homeDirectory = "/home/${user}";
  
  home.stateVersion = "23.11";

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    kitty
    lsd
    # nixd
    lua-language-server
    pavucontrol
    keepassxc
    xdg-utils
    neofetch
    btop
    onefetch
    ani-cli
    yt-dlp
    ffmpeg-full
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
    wineWowPackages.staging
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
    jetbrains.idea-community
    gimp
    r2modman
    mpvpaper
    pcmanfm
    gleam
  ];

  services.syncthing.enable = true;
  services.arrpc.enable = true;

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
