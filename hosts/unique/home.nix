{ config, pkgs, lib, user, ... }:

{
  imports = [];

  stages.pc-base = {
    enable = true;
    user = user;
  };

  stages.wayland.enable = true;

  home.stateVersion = "23.11";

  home.packages = with pkgs; [
    osu-lazer-bin
  ];

}
