{ config, pkgs, lib, user, inputs, ... }:
{
  imports =
  [
    ./hardware-configuration.nix
    ../../modules/kdeconnect.nix
  ];

  environment.systemPackages = with pkgs; [
    #lutris
    protonup-qt
    gamescope
    glibc
    dotnet-sdk
    dotnet-runtime
    signify
    inputs.deploy-rs.packages.${pkgs.stdenv.hostPlatform.system}.default
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

  # boot.kernelPackages = pkgs.linuxPackages_zen;

  networking.firewall.allowedTCPPorts = [ 8080 ];

  sops.age.keyFile = "/home/phoenix/.config/sops/age/keys.txt";
  sops.secrets.wg-private = {
    sopsFile = ../../secrets/wireguard/ramlethal/private.key;
    format = "binary";
  };

  networking.wireguard = {
    enable = true;
    interfaces = {
      "wg0" = {
        privateKeyFile = config.sops.secrets.wg-private.path;
        ips = [
          "10.1.0.1/32"
        ];

        peers = [
        {
          name = "ino";
          endpoint = "45.81.233.66:51821";
          publicKey = "vVZn+0CrS9dMBljXPEfRFUghplyopQDMUevsTnfWz38=";
          allowedIPs = [
            "10.1.0.0/24"
            "192.168.178.0/24"
          ];
          persistentKeepalive = 25;
        }
        ];
      };
    };
  };

  hardware = {
    opentabletdriver = {
      enable = true;
      daemon.enable = true;
    };
    bluetooth.enable = true;
  };

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  services.fprintd.enable = true;

  programs.steam.enable = true;

  hardware.steam-hardware.enable = true;

  environment.sessionVariables.DEFAULT_BROWSER = "${pkgs.librewolf}/bin/librewolf";
  environment.sessionVariables.DOTNET_ROOT = "${pkgs.dotnet-runtime}";

  system.stateVersion = "24.11";
}
