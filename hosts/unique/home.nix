{ config, pkgs, lib, user, ... }:

{
  imports = [];

  stages.pc-base = {
    enable = true;
    user = user;
  };

  stages.wayland.enable = true;

  programs.niri.settings.outputs = {
    "HDMI-A-2" = {
      mode = {
        width = 1920;
        height = 1080;
        refresh = 74.97;
      };
      position.x = 0;
      position.y = 0;
      scale = 1;
    };
  };

  home.stateVersion = "23.11";

  home.packages = with pkgs; [
    osu-lazer-bin
  ];

}
