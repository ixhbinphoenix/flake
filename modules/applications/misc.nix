{
  flake.modules.homeManager.misc-applications = { pkgs, ... }: {
    home.packages = with pkgs; [
      pavucontrol
      keepassxc

      signal-desktop
      vesktop
      thunderbird

      tauon
      picard
      lrcget
      calibre

      gimp

      texliveFull

      orca-slicer
      freecad
    ];
  };
}
