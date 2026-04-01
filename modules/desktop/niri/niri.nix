{ inputs, ... }: {
  flake.modules.homeManager.xwayland-satellite = { pkgs, ... }: {
    home.packages = [ pkgs.xwayland-satellite ];

    programs.niri.settings.spawn-at-startup = [
      { command = [ "xwayland-satellite" ]; }
    ];
  };

  flake.modules.homeManager.niri = { config, pkgs, ... }: {
    imports = with inputs.self.modules.homeManager; [
      xwayland-satellite
      dunst
      waybar
      kitty
    ];

    home.packages = with pkgs; [
      swww
      waypaper
      hyprpicker
    ];

    programs.niri = {
      enable = true;

      settings = {
        prefer-no-csd = true; # FUCK CSD

        input = {
          warp-mouse-to-focus.enable = true;
          focus-follows-mouse.enable = true;

          keyboard.xkb = {
            layout = "us";
            options = "compose:ralt";
          };
        };

        spawn-at-startup = [
          { command = ["wl-paste" "-t" "text" "--watch" "clipman" "store"]; }
          { command = ["swwww-daemon"]; }
        ];

        hotkey-overlay.skip-at-startup = true;

        environment = {
          "WLR_DRM_NO_ATOMIC" = "1";
          "DISPLAY" = ":0";
          "MOZ_ENABLE_WAYLAND" = "1";
          "MOZ_DBUS_REMOTE" = "1";
          "SDL_VIDEODRIVER" = "wayland";
          "QT_QPA_PLATFORM" = "wayland";
          "_JAVA_AWT_WM_NONREPARENTING" = "1";
          "ELECTRON_OZONE_PLATFORM_HINT" = "auto";
        };

        cursor = {
          size = 24;
        };

        binds = with config.lib.niri.actions; let
          sh = spawn "sh" "-c";
        in {
          "Super+Shift+w".action = spawn "random_wallpaper"; # TODO: better spot for these binds, and make this script real
          "Super+w".action = spawn "waypaper";
          "Super+P".action = sh "hyprpicker | wl-copy";

          "Super+o".action = show-hotkey-overlay;

          "Super+Shift+s".action = sh "screenshot --area --upload"; # TODO: better spot for this bind and make this script real

          "Super+f".action = fullscreen-window;
          "Super+m".action = maximize-column;
          "Super+c".action = center-column;
          "Super+Shift+q".action = close-window;

          "Super+h".action = focus-column-or-monitor-left;
          "Super+j".action = focus-window-down;
          "Super+k".action = focus-window-up;
          "Super+l".action = focus-column-or-monitor-right;

          "Super+Shift+h".action = consume-or-expel-window-left;
          "Super+Shift+j".action = move-window-down;
          "Super+Shift+k".action = move-window-down;
          "Super+Shift+l".action = consume-or-expel-window-right;

          "Super+Shift+Ctrl+h".action = move-column-to-monitor-left;
          "Super+Shift+Ctrl+l".action = move-column-to-monitor-right;
          "Super+Ctrl+h".action = focus-monitor-left;
          "Super+Ctrl+l".action = focus-monitor-right;

          "Super+A".action = focus-workspace-down;
          "Super+D".action = focus-workspace-up;
          "Super+Shift+A".action = move-window-to-workspace-down;
          "Super+Shift+D".action = move-window-to-workspace-up;
        };

        layout = {
          gaps = 5;

          center-focused-column = "on-overflow";

          default-column-width.proportion = 0.5;

          struts = {
            left = 10;
            right = 10;
            top = 10;
            bottom = 10;
          };

          border = {
            enable = true;
            width = 3;

            active.color = "#cba6f7";
            inactive.color = "#6c7086";
          };

          focus-ring.enable = false;
        };

        window-rules = [{
          matches = [{
            app-id = "^org.keepassxc.KeePassXC$";
          }];

          block-out-from = "screen-capture";
        }];

        layer-rules = [{
          matches = [{
            namespace = "notifications";
          }];

          block-out-from = "screen-capture";
        }];
      };
    };
  };
}
