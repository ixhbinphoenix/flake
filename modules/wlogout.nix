{ pkgs, ... }:
{
  imports = [];

  options = {};

  config = {
    programs.wlogout = {
      enable = true;
      layout = [
      {
        label = "shutdown";
        action = "systemctl poweroff";
        text = "Shutdown";
        keybind = "s";
      }
      {
        label = "reboot";
        action = "systemctl reboot";
        text = "Reboot";
        keybind = "r";
      }
      ];
    };
  };
}
