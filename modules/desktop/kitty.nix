{
  flake.modules.homeManager.catppuccin = {
    catppuccin.kitty.enable = true;
  };

  flake.modules.homeManager.kitty = { config, ... }: {
    programs.niri.settings.binds."Super+Return".action = config.lib.niri.actions.spawn "kitty";

    programs.kitty = {
      enable = true;

      font = {
        name = "Iosevka Term";
        size = 10;
      };

      settings = {
        background_opacity = "0.9";
        scrollback_lines = 20000;
        open_url_with = "default"; # TODO: Fix xdg-open
        enable_audio_bell = "no";
        url_style = "curly";
        adjust_column_width = 2;
      };
    };
  };
}
