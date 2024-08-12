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

      pointerCursor = {
        enable = true;
        accent = "dark";
      };
    };

    gtk.catppuccin = {
      enable = true;

      icon = {
        enable = true;
      };
    };

    programs.mpv = {
      enable = true;
      catppuccin.enable = true;
    };

    home.packages = with pkgs; [
      pavucontrol
      keepassxc
      ani-cli
      yt-dlp
      prismlauncher
      tenacity

      #gpodder
      #nyxt
      transmission_4-qt
      trackma-qt
      vesktop
      strawberry
      nheko
      gimp
      mpvpaper
      pcmanfm

      obsidian

      swww
      thunderbird
      cava
    ];

    services.syncthing.enable = true;
    services.arrpc.enable = true;
    services.network-manager-applet.enable = true;

    programs.librewolf.enable = true;
    home.file.".librewolf/native-messaging-hosts/org.kde.plasma.browser_integration.json".source = "${pkgs.kdePackages.plasma-browser-integration}/lib/mozilla/native-messaging-hosts/org.kde.plasma.browser_integration.json";
  };
}
