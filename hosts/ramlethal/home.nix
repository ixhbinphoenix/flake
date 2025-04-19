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
    "DP-4" = {
      mode = {
        width = 1920;
        height = 1080;
        refresh = 60.0;
      };
      scale = 1;
    };
    "DP-12" = {
      mode = {
        width = 1920;
        height = 1080;
        refresh = 60.0;
      };
      scale = 1;
      position.x = 4480;
      position.y = 0;
    };
    "DP-10" = {
      mode = {
        width = 1920;
        height = 1080;
        refresh = 60.0;
      };
      scale = 1;
      position.x = 2560;
      position.y = 0;
    };
  };
  programs.niri.settings.input = {
    touchpad = {
      disabled-on-external-mouse = false;
      # FUCK NATURAL SCROLL!!!!!!
      # PIECE OF SHIT!!!!
      natural-scroll = false;
      scroll-method = "two-finger";
    };
  };
  programs.niri.settings.debug = {
    render-drm-device = "/dev/dri/renderD128";
  };

  home.stateVersion = "24.11";

  home.packages = with pkgs; [
    osu-lazer-bin
    #orca-slicer
  ];
}
