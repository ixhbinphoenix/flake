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

  programs.librewolf.enable = true;

  programs.git.extraConfig.user.signingkey = "BA62877F1E9D4833";

  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };
  };

  services.clipman.enable = true;
}
