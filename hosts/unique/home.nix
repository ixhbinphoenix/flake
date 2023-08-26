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
    thunderbird
    osu-lazer-bin
    youtube-music
  ];

  programs.git.extraConfig.user.signingkey = "A80D9E94F66ED077";

  programs.librewolf.enable = true;

  services.clipman.enable = true;
}
