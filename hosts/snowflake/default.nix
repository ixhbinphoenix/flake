{ config, pkgs, lib, user, ... }:
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
    wlprop
    obs-studio
    obs-studio-plugins.wlrobs
    obs-studio-plugins.obs-vaapi
    obs-studio-plugins.obs-vkcapture
    obs-studio-plugins.obs-pipewire-audio-capture
    unityhub
    distrobox
    lutris
    protonup-qt
    gamescope
    virt-manager
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "snowflake";

  hardware = {
    opengl = {
      enable = true;
      driSupport32Bit = true;
    };
    opentabletdriver = {
      enable = true;
      daemon.enable = true;
    };
  };

  virtualisation.libvirtd.enable = true;
  programs.dconf.enable = true;

  users.users.${user}.extraGroups = [ "libvirtd" ];

  services.dbus.enable = true;
  xdg = {
    portal = {
      enable = true;
      wlr.enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    };
    mime = {
      enable = true;

      defaultApplications = {
        "text/html" = "librewolf.desktop";
        "x-scheme-handler/http" = "librewolf.desktop";
        "x-scheme-handler/about" = "librewolf.desktop";
        "x-scheme-handler/unknown" = "librewolf.desktop";
      };
    };
  };

  security.pam.services.swaylock.text = ''
    auth include login
  '';

  programs.steam.enable = true;

  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };

  environment.sessionVariables.DEFAULT_BROWSER = "${pkgs.librewolf}/bin/librewolf";

  system.stateVersion = "23.05";
}
