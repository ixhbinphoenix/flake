{ inputs, config, pkgs, lib, user, ... }:
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
    inputs.deploy-rs.packages.${pkgs.system}.default
    wineWowPackages.stagingFull
    winetricks
    protontricks
    localsend
    nur.repos.ixhbinphoenix.localbooru-bin
    #jetbrains.idea-community-bin
    #jetbrains.rider
    android-studio
    stash
  ];

  programs.honkers-railway-launcher.enable = true;
  programs.anime-game-launcher.enable = true;
  programs.sleepy-launcher.enable = true;

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
    "167.235.25.252" = ["minio.plasmatrap.com" "imgproxy.plasmatrap.com"];
  };

  networking.firewall.allowedTCPPorts = [ 7590 9999 ];

  hardware = {
    opentabletdriver = {
      enable = true;
      daemon.enable = true;
    };
    graphics.extraPackages = with pkgs; [
      rocmPackages.clr
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
