{ config, pkgs, lib, ... }:
with lib;
{
  imports = [
    ../../modules/wlogout.nix
    ../../modules/anyrun.nix
    ../../modules/kitty
    ../../modules/hyprland
    ../../modules/niri
  ];

  options.stages.wayland = {
    enable = mkEnableOption "Wayland home-manager config";
  };

  config = mkIf config.stages.wayland.enable {
    assertions = [
      {
        assertion = config.stages.pc-base.enable;
        message = ''
          Stage Wayland depends on the pc-base Stage
        '';
      }
    ];

    #hyprland.enable = true;
    niri.enable = true;

    catppuccin = {
      enable = true;
      accent = "mauve"; # default options, let's fucking go
      flavor = "mocha";

      cursors = {
        enable = true;
        accent = "dark";
      };

      gtk = {
        enable = true;
        icon.enable = true;
      };

      mpv.enable = config.programs.mpv.enable;
    };

    programs.mpv = {
      enable = true;
    };

    home.packages = with pkgs; [
      pavucontrol
      keepassxc
      ani-cli
      yt-dlp
      prismlauncher
      everest-mons # nix package for olympus when
      tenacity
      hyprpicker

      gpodder

      qbittorrent

      # TODO: https://github.com/NixOS/nixpkgs/issues/377206
      #trackma-qt
      vesktop
      strawberry
      tauon
      #nheko # When are those CVE's getting fixed wtf
      signal-desktop
      gajim
      gimp
      mpvpaper
      pcmanfm

      obsidian

      swww
      waypaper
      thunderbird
      cava
    ];

    services.syncthing.enable = true;
    services.arrpc.enable = true;
    #services.network-manager-applet.enable = true;

    programs.librewolf.enable = true;
    home.file.".librewolf/native-messaging-hosts/org.kde.plasma.browser_integration.json".source = "${pkgs.kdePackages.plasma-browser-integration}/lib/mozilla/native-messaging-hosts/org.kde.plasma.browser_integration.json";
  };
}
