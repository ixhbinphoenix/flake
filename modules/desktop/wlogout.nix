{
  flake.modules.homeManager.wlogout = { config, ... }: {
    programs.niri.settings.binds."Super+F4".action = config.lib.niri.actions.spawn "wlogout";

    programs.wlogout = {
      enable = true;
      layout = [
      {
        label = "shutdown";
        action = "systemctl poweroff";
        text = "Shutdown (s)";
        keybind = "s";
      }
      {
        label = "reboot";
        action = "systemctl reboot";
        text = "Reboot (r)";
        keybind = "r";
      }
      ];
    };
  };
}
