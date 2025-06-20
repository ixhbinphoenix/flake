{...}: 
{
  imports = [];

  options = {};

  config = {
    programs.waybar = {
      enable = true;
      settings = {
        main = {
          layer = "bottom";
          position = "top";
          spacing = 5;
          modules-left = [
            "mpris"
            "cava"
          ];
          modules-center = [
            "niri/window"
          ];
          modules-right = [
            "image#ampel"
            "tray"
            "battery"
            "network"
            "clock"
          ];

          "image#ampel" = {
            exec = "curl https://ampel.entropia.de/ampel.png --output /tmp/ampel.png;
            echo /tmp/ampel.png";
            size = 32;
            interval = 10;
          };

          "niri/window" = {
            format = "{}";
            icon = false;
            rewrite = {
              "LibreWolf" = "󰈹 ";
              "(.*) — LibreWolf" = "󰈹  - $1";
              "(.*) - YouTube — LibreWolf" = "󰗃  - $1";
              "(.*) Strawberry Music Player" = "󰦚 ";
              "nvim" = "";
              "Neovide" = "";
              "zsh" = " ";
            };
          };

          mpris = {
            format = "  {title} - {artist}";
            format-paused = "󰏤 {title} - {artist}";
            interval = 1;
          };

          cava = {
            framerate = 60;
            autosens = 1;
            bars = 20;
            lower_cutoff_freq = 50;
            higher_cutoff_freq = 10000;
            method = "pipewire";
            source = "auto";
            stereo = true;
            bar_delimiter = 0;
            input_delay = 0;
            format-icons = ["▁" "▂" "▃" "▄" "▅" "▆" "▇" "█"];
          };

          network = {
            format-wifi = "  {essid}";
            format-ethernet = "󰈁 {ipaddr}/{cidr}";
            format-linked = "󰈂 (no ip)";
            format-disconnected = "󰈂";
            family = "ipv4";
            tooltip = false;
          };

          clock = {
            format = "󰥔 {:%H:%M}";
            tooltip-format = "{:%H:%M %d %B %Y}";
          };

          tray = {
            spacing = 5;
          };
        };
      };
      style = ''
        @define-color bg #1e1e2e;
        @define-color text #cdd6f4;

        @define-color blue      #89b4fa;
        @define-color lavender  #b4befe;
        @define-color sapphire  #74c7ec;
        @define-color sky       #89dceb;
        @define-color teal      #94e2d5;
        @define-color green     #a6e3a1;
        @define-color yellow    #f9e2af;
        @define-color peach     #fab387;
        @define-color maroon    #eba0ac;
        @define-color red       #f38ba8;
        @define-color mauve     #cba6f7;
        @define-color pink      #f5c2e7;
        @define-color flamingo  #f2cdcd;
        @define-color rosewater #f5e0dc;

        * {
          font-family: "Iosevka Nerd Font";
          font-size: 14px;
        }

        window#waybar {
          background: transparent;
          color: @text;
        }

        #mpris,
        #cava,
        #window,
        #tray,
        #battery,
        #network,
        #clock,
        #ampel{
          background: @bg;
          border: 2px solid @mauve;
          border-radius: 10px;
          margin-top: 5px;
          padding: 5px;
        }

        .modules-left {
          margin-left: 5px;
        }

        .modules-right {
          margin-right: 5px;
        }
      '';
    };
  };
}
