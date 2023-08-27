{ config, pkgs, lib, user, ... }:
{
  imports =
  [
    ./hardware-configuration.nix
  ];

  environment.systemPackages = with pkgs; [
    swaylock
    swayidle
    unityhub
    distrobox
    lutris
    protonup-qt
    gamescope
    virt-manager
    amf-headers
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
    opengl.extraPackages = with pkgs; [
      amdvlk
      rocm-opencl-icd
      rocm-opencl-runtime
      nur.repos.materus.amdgpu-pro-libs.amf
    ];
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
