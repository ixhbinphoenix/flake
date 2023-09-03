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
    libsForQt5.kdenlive
    cava
  ];

  programs.librewolf.enable = true;

  programs.obs-studio = {
    enable = true;
    package = pkgs.nur.repos.materus.obs-amf;
    plugins = with pkgs.obs-studio-plugins; [
      advanced-scene-switcher
      wlrobs
      input-overlay
      obs-vaapi
      obs-gstreamer
      obs-vkcapture
      obs-pipewire-audio-capture
    ];
  };

  programs.git.extraConfig.user.signingkey = "BA62877F1E9D4833";

  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };
  };

  services.clipman.enable = true;
}
