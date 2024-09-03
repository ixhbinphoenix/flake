{ config, pkgs, lib, user, ... }:

{
  imports = [];

  stages.pc-base = {
    enable = true;
    user = user;
  };

  stages.wayland.enable = true;

  programs.niri.settings.outputs = {
    "eDP-2" = {
      mode = {
        width = 2560;
        height = 1600;
        refresh = 165.0;
      };
      position.x = 0;
      position.y = 0;
      scale = 1.5;
    };
  };
  programs.niri.settings.input = {
    touchpad = {
      disabled-on-external-mouse = true;
      # FUCK NATURAL SCROLL!!!!!!
      # PIECE OF SHIT!!!!
      natural-scroll = false;
      scroll-method = "two-finger";
    };
  };

  home.stateVersion = "24.11";

  home.packages = with pkgs; [
    osu-lazer-bin
  ];
}
