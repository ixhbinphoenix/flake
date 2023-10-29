{pkgs, anyrun, ...}: {
  programs.anyrun = {
    enable = true;
    config = {
      plugins = [
        anyrun.packages.${pkgs.system}.applications
      ];
      width = { fraction = 0.3; };
      height = { absolute = 0; };
      hideIcons = false;
      ignoreExclusiveZones = false;
      layer = "overlay";
      hidePluginInfo = true;
      closeOnClick = true;
      showResultsImmediately = true;
      maxEntries = null;
    };
    extraCss = ''
      window {
        opacity: 0%;
      }
    '';
  };
}
