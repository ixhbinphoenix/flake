# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ config, pkgs, lib, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
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
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "qemu-nix"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  networking.firewall.allowedTCPPorts = [ 22000 8384 ];

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable OpenGL
  hardware.opengl.enable = true;


  services.dbus.enable = true;
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = lib.mkOverride 1000 true;

  # Make swaylock work
  security.pam.services.swaylock.text = ''
    # PAM Configuration file for the swaylock screen locker. By default it includes
    # the 'login' configuration file (see /etc/pam.d/login)
    auth include login
  '';

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}

