{ config, pkgs, lib, user, inputs, ... }:
{
  imports =
  [
    ./hardware-configuration.nix
    ../../modules/kdeconnect.nix
  ];

  environment.systemPackages = with pkgs; [
    lutris
    protonup-qt
    gamescope
    glibc
    dotnet-sdk
    dotnet-runtime
    signify
    inputs.deploy-rs.packages.${pkgs.system}.default
    wineWowPackages.stagingFull
    winetricks
    protontricks
    nur.repos.ixhbinphoenix.localbooru-bin
    #jetbrains.idea-community-bin
  ];

  stages.pc-base = {
    enable = true;
    user = user;

    bootloader.systemd-boot.enable = true;

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

  programs.sleepy-launcher.enable = true;

  boot.kernelPackages = pkgs.linuxPackages_zen;

  networking.hosts = {
    "192.168.172.189" = ["twinkpad"];
    "192.168.172.39" = ["snowflake"];
  };

  networking.firewall.allowedTCPPorts = [ 8080 ];

  hardware = {
    opentabletdriver = {
      enable = true;
      daemon.enable = true;
    };
    bluetooth.enable = true;
  };

  services.fprintd.enable = true;

  programs.steam.enable = true;

  hardware.steam-hardware.enable = true;

  environment.sessionVariables.DEFAULT_BROWSER = "${pkgs.librewolf}/bin/librewolf";
  environment.sessionVariables.DOTNET_ROOT = "${pkgs.dotnet-runtime}";

  system.stateVersion = "24.11";
}
