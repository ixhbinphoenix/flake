{ config, pkgs, lib, user, ... }:
{
  imports =
  [
    ./hardware-configuration.nix
    ./vfio
  ];

  fonts.packages = with pkgs; [
    nur.repos.suhr.iosevka-term
  ];

  environment.systemPackages = with pkgs; [
    swaylock
    swayidle
    distrobox
    lutris
    protonup-qt
    gamescope
    virt-manager
    glibc
    dotnet-sdk
    dotnet-runtime
    android-tools
    android-udev-rules
    signify
    wootility
  ];

  boot.kernelPackages = pkgs.linuxPackages_zen;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.supportedFilesystems = [ "ntfs" ];

  networking.hostName = "snowflake";

  networking.hosts = {
    "192.168.172.189" = ["twinkpad"];
  };

  hardware = {
    opentabletdriver = {
      enable = true;
      daemon.enable = true;
    };
    opengl.extraPackages = with pkgs; [
      rocm-opencl-icd
      rocm-opencl-runtime
      nur.repos.materus.amdgpu-pro-libs.amf
    ];
    bluetooth.enable = true;
  };

  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;

  programs.adb.enable = true;

  users.users.${user}.extraGroups = [ "libvirtd" "plugdev" ];


  security.pam.services.swaylock.text = ''
    auth include login
  '';

  programs.steam.enable = true;

  hardware.steam-hardware.enable = true;

  virtualisation.docker = {
    enable = true;
  };

  virtualisation.waydroid.enable = true;

  environment.sessionVariables.DEFAULT_BROWSER = "${pkgs.librewolf}/bin/librewolf";
  environment.sessionVariables.DOTNET_ROOT = "${pkgs.dotnet-runtime}";

  system.stateVersion = "23.05";
}
