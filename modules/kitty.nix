{pkgs, ...}:
{
  imports = [];
  
  options = {};

  config = {
    programs.kitty = {
      enable = true;
      
      font = {
        name = "Iosevka Term";
        size = 10;
      };
      
      settings = {
        background_opacity = "0.9";
        scrollback_lines = 20000;
        open_url_with = "default";
        enable_audio_bell = "no";
        url_style = "curlky";
        adjust_column_width = 2;
      };
    };

    catppuccin.kitty.enable = true;
  };
}
