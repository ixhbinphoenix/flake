{ config, pkgs, lib, user, ... }:

{
  imports = [];

  stages.pc-base = {
    enable = true;
    user = user;
  };

  stages.wayland.enable = true;

  programs.niri.settings.outputs = {
    "DP-2" = {
      mode = {
        width = 1920;
        height = 1080;
        refresh = 60.0;
      };
      position.x = -1920;
      position.y = 0;
      scale = 1;
    };
    "DP-1" = {
      mode = {
        width = 2560;
        height = 1440;
        refresh = 143.912;
      };
      position.x = 0;
      position.y = 0;
      scale = 1;
    };
    "HDMI-A-1" = {
      mode = {
        width = 1600;
        height = 900;
        refresh = 60.0;
      };

      position.x = 2560;
      position.y = 0;
      scale = 1;
    };
  };


  home.stateVersion = "23.11";

  home.packages = with pkgs; [
    osu-lazer-bin
    youtube-music
    libsForQt5.kdenlive
    BeatSaberModManager
    avalonia-ilspy
    scanmem
    godot_4
    blender
    orca-slicer
  ];

  programs.obs-studio = {
    enable = true;
    package = pkgs.obs-studio;
    plugins = with pkgs.obs-studio-plugins; [
      #advanced-scene-switcher
      wlrobs
      input-overlay
      obs-vaapi
      obs-gstreamer
      obs-vkcapture
      obs-pipewire-audio-capture
    ];
  };

  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };
  };
}
