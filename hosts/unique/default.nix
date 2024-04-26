# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ config, pkgs, user, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];
  
  stages.pc-base = {
    enable = true;
    user = user;
    hostname = "unique";

    bootloader.systemd-boot.enable = true;
    bootloader.multi-boot = true;

    localization = {
      timeZone = "Europe/Berlin";
      locale = "en_US.UTF-8";
      LC_TIME = "de_DE.UTF-8";
      LC_MONETARY = "de_DE.UTF-8";
      keyMap = "us";
    };
    
    sleep = true;
  };

  stages.wayland = {
    enable = true;
    desktop.hyprland.enable = true;
    desktop.greetd.cmd = "Hyprland";
  };

  # TODOO: New gaming stage
  environment.systemPackages = with pkgs; [
    lutris
    protonup-qt
    gamescope
    wineWowPackages.stagingFull
    winetricks
    protontricks
  ];

  boot.kernelPackages = pkgs.linuxPackages_zen;

  hardware.bluetooth.enable = true;

  programs.steam.enable = true;

  system.stateVersion = "23.05";
}

