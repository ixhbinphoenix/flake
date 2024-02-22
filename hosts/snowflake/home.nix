{ config, pkgs, lib, user, ... }:

{
  imports = [
    ../../modules/desktop/hyprland
    ../../modules/programs/waybar
    ../../modules/programs/dunst.nix
  ];

  home.packages = with pkgs; [
    waybar
    swww
    flameshot
    nur.repos.aleksana.yofi
    thunderbird
    osu-lazer-bin
    youtube-music
    libsForQt5.kdenlive
    cava
    cemu-ti
    BeatSaberModManager
    avalonia-ilspy
    scanmem
    godot_4
    blender
    citra-nightly
  ];

  programs.librewolf.enable = true;

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

  services.clipman.enable = true;
}
