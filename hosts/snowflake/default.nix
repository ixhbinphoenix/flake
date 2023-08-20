{ config, pkgs, lib, ... }:
{
  imports =
  [
    ./hardware-configuration.nix
    ../../modules/desktop/greetd
  ];

  environment.systemPackages = with pkgs; [
    wayland
    egl-wayland
    glib
    swaylock
    swayidle
    grim
    slurp
    wl-clipboard
    obs-studio
    obs-studio-plugins.wlrobs
    obs-studio-plugins.obs-vaapi
    obs-studio-plugins.obs-vkcapture
    obs-studio-plugins.obs-pipewire-audio-capture
    unityhub
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "snowflake";

  hardware.opengl.enable = true;

  services.dbus.enable = true;
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  security.pam.services.swaylock.text = ''
    auth include login
  '';

  programs.steam.enable = true;

  system.stateVersion = "23.05";
}
