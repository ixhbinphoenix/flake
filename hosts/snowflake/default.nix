{ config, pkgs, lib, user, deploy-rs, ... }:
{
  imports =
  [
    ./hardware-configuration.nix
    ./vfio
    ../../modules/kdeconnect.nix
  ];

  environment.systemPackages = with pkgs; [
    distrobox
    lutris
    bottles
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
    wineWowPackages.stagingFull
    winetricks
    protontricks
    xivlauncher
    localsend
    nur.repos.ixhbinphoenix.localbooru-bin
    jetbrains.idea-community-bin
    android-studio
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
    desktop.niri.enable = true;
    desktop.greetd.cmd = "niri-session";
  };

  boot.kernelPackages = pkgs.linuxPackages_zen;

  networking.hosts = {
    "192.168.172.189" = ["twinkpad"];
    "192.168.172.115" = ["ramlethal"];
  };

  hardware = {
    opentabletdriver = {
      enable = true;
      daemon.enable = true;
    };
    graphics.extraPackages = with pkgs; [
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
