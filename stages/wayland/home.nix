{ config, pkgs, lib, ... }:
with lib;
{
  imports = [
    ../../modules/wlogout.nix
    ../../modules/anyrun.nix
    ../../modules/kitty
    ../../modules/hyprland
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

    hyprland.enable = true;

    home.packages = with pkgs; [
      pavucontrol
      keepassxc
      ani-cli
      yt-dlp
      mpv
      prismlauncher
      tenacity

      gpodder
      #nyxt
      transmission-qt
      trackma-qt
      vesktop
      strawberry
      nheko
      gimp
      mpvpaper
      pcmanfm

      swww
      thunderbird
      cava
    ];

    services.syncthing.enable = true;
    services.arrpc.enable = true;
    services.network-manager-applet.enable = true;

    programs.librewolf.enable = true;
  };
}
