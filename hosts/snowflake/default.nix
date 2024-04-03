{ config, pkgs, lib, user, deploy-rs, ... }:
{
  imports =
  [
    ./hardware-configuration.nix
    ./vfio
  ];

  environment.systemPackages = with pkgs; [
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
    deploy-rs.packages.x86_64-linux.default
  ];

  stages.pc-base = {
    enable = true;
    user = user;
    hostname = "snowflake";

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

  boot.kernelPackages = pkgs.linuxPackages_zen;

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

  programs.steam.enable = true;

  hardware.steam-hardware.enable = true;

  virtualisation.waydroid.enable = true;

  environment.sessionVariables.DEFAULT_BROWSER = "${pkgs.librewolf}/bin/librewolf";
  environment.sessionVariables.DOTNET_ROOT = "${pkgs.dotnet-runtime}";

  system.stateVersion = "23.05";
}
