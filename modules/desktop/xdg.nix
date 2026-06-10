{
  flake.modules.nixos.xdg = { pkgs, ... }: {
    # Do these fit here? Probably not
    # Do i even know what this is? Probably not!
    services.dbus.enable = true;
    security.polkit.enable = true;
    programs.dconf.enable = true;

    xdg = {
      portal = {
        enable = true;
        xdgOpenUsePortal = true;
        extraPortals = with pkgs; [
          xdg-desktop-portal-gtk
          xdg-desktop-portal-gnome
        ];
        config.common.default = "*";
      };

      mime = {
        enable = true;

        defaultApplications = {
          "text/html" = "librewolf.desktop";
          "x-scheme-handler/http" = "librewolf.desktop";
          "x-scheme-handler/https" = "librewolf.desktop";
        };
      };
    };
  };
}
