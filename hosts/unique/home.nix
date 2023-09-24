{ config, pkgs, lib, user, ... }:

{
  imports = [
    ../../modules/desktop/sway
    ../../modules/programs/waybar
    ../../modules/programs/dunst.nix
  ];

  home.packages = with pkgs; [
    waybar
    swww
    flameshot
    nur.repos.aleksana.yofi
    armcord
    discord
    thunderbird
    osu-lazer-bin
    youtube-music
  ];

  programs.librewolf.enable = true;

  services.clipman.enable = true;
}
