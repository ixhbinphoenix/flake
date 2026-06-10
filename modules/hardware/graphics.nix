{
  flake.modules.nixos.default-graphics = { pkgs, ... }: {
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };
    hardware.enableRedistributableFirmware = true;

    environment.variables = {
      WLR_DRM_NO_ATOMIC = "1";
      DISPLAY = ":0";
      MOZ_ENABLE_WAYLAND = "1";
      MOZ_DBUS_REMOTE = "1";
      SDL_VIDEODRIVER = "wayland";
      QT_QPA_PLATFORM = "wayland";
      _JAVA_AWT_WM_NONREPARENTING = "1";
      ELECTRON_OZONE_PLATFORM_HINT = "auto";
    };

    environment.systemPackages = with pkgs; [
      mesa
      wayland
      egl-wayland
      glib
      xwayland-satellite
    ];
  };
}
