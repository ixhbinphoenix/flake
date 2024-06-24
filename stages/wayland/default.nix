{ config, lib, pkgs, ... }:
with lib;
{
  imports = [
    ../../modules/greetd.nix
    ../../modules/kdeconnect.nix
  ];

  options.stages.wayland = {
    enable = mkEnableOption "Wayland GUI + Some nice programs";
  
    desktop = {
      hyprland = {
        enable = mkEnableOption "Hyprland as a Window Manager";
      };

      sway = {
        enable = mkEnableOption "Sway as a Window Manager";
      };

      greetd = {
        cmd = mkOption {
          type = types.nonEmptyStr;
          example = "Hyprland";
          description = ''
            The command that gets executed by greetd. Should be the compositor
          '';
        };
      };
    };
  };

  config = mkIf config.stages.wayland.enable (mkMerge [{
    assertions = [
      {
        assertion = config.stages.pc-base.enable;
        message = ''
          Stage Wayland depends on the pc-base Stage
        '';
      }
    ];

    greetd.cmd = config.stages.wayland.desktop.greetd.cmd;

    hardware.opengl = {
      enable = true;
      driSupport32Bit = true;
    };

    xdg = {
      portal = {
        enable = true;
        extraPortals = with pkgs; [
          pkgs.xdg-desktop-portal-gtk
          #(mkIf config.stages.wayland.desktop.hyprland.enable (
            #pkgs.xdg-desktop-portal-hyprland
          #))
        ];
        config.common.default = "*";
      };
      mime = {
        enable = true;

        defaultApplications = {
          "text/html" = "librewolf.desktop";
          "x-scheme-handler/http" = "librewolf.desktop";
          "x-scheme-handler/about" = "librewolf.desktop";
          "x-scheme-handler/unknown" = "librewolf.desktop";
          "video/mp4" = "mpv.desktop";
          "audio/aac" = "mpv.desktop";
          "image/gif" = "mpv.desktop";
          "image/png" = "qiv.desktop";
          "image/jpeg" = "qiv.desktop";
          "image/tiff" = "qiv.desktop";
          "image/webp" = "qiv.desktop";
          "text/plain" = "nvim.desktop";
        };
      };
    };


    environment = {
      variables = {
        TERMINAL = "kitty"; # This has a dependency on OpenGL 3.(0?) and so isn't supported by my Thinkpad T400
        BROWSER = "librewolf";
        MOZ_ENABLE_WAYLAND = "1";
        MOZ_DBUS_REMOTE = "1";
        SDL_VIDEODRIVER = "wayland";
        QT_QPA_PLATFORM = "wayland";
        _JAVA_AWT_WM_NONREPARENTING = "1";
        ELECTRON_OZONE_PLATFORM_HINT = "auto";
      };
      systemPackages = with pkgs; [
        mesa
        xdg-utils
        libnotify
        dunst
        wayland
        egl-wayland
        glib
        wl-clipboard
        wlprop
        mpv
        qiv
      ];
    };

    fonts = {
      packages = with pkgs; [
        nur.repos.suhr.iosevka-term
        iosevka
        (nerdfonts.override { fonts = [ "Iosevka" "IosevkaTerm" ]; })
        source-code-pro
        font-awesome
        noto-fonts-emoji
        ipafont
      ];
      fontconfig.defaultFonts = {
        emoji = [ "Iosevka Nerd Font" "Noto Emoji" "Font Awesome" ];
        monospace = [ "Iosevka Term Nerd Font" "Source Code Pro" ];
        sansSerif = [ "Iosevka Nerd Font" "IPAFont" ];
      };
    };
  }
  (mkIf config.stages.wayland.desktop.sway.enable {
    environment.variables.XDG_CURRENT_DESKTOP = "sway";
  })

  # Should take priority?
  (mkIf config.stages.wayland.desktop.hyprland.enable {
    environment.variables.XDG_CURRENT_DESKTOP = "hyprland";
    programs.hyprland.enable = true;
    programs.hyprland.xwayland.enable = true;
  })
  ]);
}
