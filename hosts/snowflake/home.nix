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
    youtube-music
    libsForQt5.kdenlive
    cemu-ti
    BeatSaberModManager
    avalonia-ilspy
    scanmem
    godot_4
    blender
  ];

  programs.obs-studio = {
    enable = true;
    package = pkgs.nur.repos.materus.obs-amf;
    plugins = with pkgs.obs-studio-plugins; [
      # advanced-scene-switcher
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
