{ config, pkgs, lib, user, ... }:
{
  imports = [
    ../../scripts.nix
    ../../modules/zsh
    ../../modules/bat.nix
    ../../modules/git.nix
    ../../modules/tmux.nix
    ../../modules/nixvim.nix
  ];
  home.username = "${user}";
  home.homeDirectory = "/home/${user}";

  home.stateVersion = "23.11";

  programs.home-manager.enable = true;


  home.packages = with pkgs; [
    lsd
    pavucontrol
    keepassxc
    xdg-utils
    hyfetch
    btop
    onefetch
    ffmpeg-full
    mpv
    p7zip
    mediainfo
    websocat
    yubioath-flutter
    nyxt
    nur.repos.ixhbinphoenix.todoit
    miniserve
    transmission-qt
    strawberry
    nheko
    mpvpaper
    pcmanfm
  ];

  services.syncthing.enable = true;
  

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
