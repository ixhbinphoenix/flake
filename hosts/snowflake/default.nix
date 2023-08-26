{ config, pkgs, lib, user, ... }:
{
  imports =
  [
    ./hardware-configuration.nix
  ];

  environment.systemPackages = with pkgs; [
    swaylock
    swayidle
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

  boot.kernelPackages = pkgs.linuxPackages_zen;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "snowflake";

  hardware = {
    opentabletdriver = {
      enable = true;
      daemon.enable = true;
    };
  };

  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;

  users.users.${user}.extraGroups = [ "libvirtd" ];

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
