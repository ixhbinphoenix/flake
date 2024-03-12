# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ config, pkgs, user, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  fonts.packages = with pkgs; [
    nur.repos.suhr.iosevka-term
  ];

  environment.systemPackages = with pkgs; [
    swaylock
    swayidle
    lutris
    protonup-qt
    gamescope
  ];

  boot.kernelPackages = pkgs.linuxPackages_zen;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "unique";

  hardware.bluetooth.enable = true;

  virtualisation.docker.enable = true;

  users.users.${user}.extraGroups = [ "docker" ];

  programs.steam.enable = true;

  system.stateVersion = "23.05";
}

