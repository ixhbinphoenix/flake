{ config, pkgs, ...}:
{
  imports = [];

  options = {};

  config = {
    catppuccin.dunst.enable = config.services.dunst.enable;
    services.dunst = {
      enable = true;
      settings = {
        global = {
          follow = "mouse";
          width = 500;
          height = 300;
          origin = "top-right";
          offset = "15x30";
          scale = 0;
          notification_limit = 4;

          progress_bar = false;

          indicate_hidden = "yes";
          transparency = 0;
          seperator_height = 2;
          padding = 8;
          horizontal_padding = 8;
          text_icon_padding = 0;
          frame_width = 4;
          seperator_color = "frame";
          sort = "yes";


          font = "Monospace 8";
          markup = "full";
          format = ''"<b>%s</b> %p\n%b"'';
          alignment = "left";
          vertical_alignment = "center";
          show_age_threshold = 60;
          ellipsize = "middle";
          ignore_newline = "no";
          stack_duplicates = true;
          hide_duplicate_count = false;
          show_indicators = "yes";

          icon_position = "off";
          min_icon_size = 0;
          max_icon_size = 32;

          sticky_history = "yes";
          history_length = 20;

          dmenu = "${pkgs.dmenu}/bin/dmenu -p dunst:";
          browser = "${pkgs.xdg-utils}/bin/xdg-open";
          always_run_script = true;
          title = "Dunst";
          class = "Dunst";

          corner_radius = 0;
          ignore_dbusclose = false;

          force_xwayland = false;

          force_xinerama = false;

          mouse_left_click = "close_current";
          mouse_middle_click = "open_url, close_current";
          mouse_right_click = "do_action, close_current";
        };
        experimental = {
          per_monitor_dpi = false;
        };
        urgency_low = {
          timeout = 10;
        };
        urgency_normal = {
          timeout = 10;
        };
        urgency_critical = {
          timeout = 0;
        };
      };
    };
  };
}
