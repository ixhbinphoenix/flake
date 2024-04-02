{ config, pkgs, lib, user, ... }:

{
  imports = [
    ../../modules/hyprland
    ../../modules/waybar
    ../../modules/dunst.nix
  ];

  home.packages = with pkgs; [
    waybar
    swww
    flameshot
    nur.repos.aleksana.yofi
    thunderbird
    osu-lazer-bin
    youtube-music
  ];

  programs.librewolf.enable = true;

  services.clipman.enable = true;
}
