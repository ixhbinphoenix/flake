{pkgs, anyrun, ...}: {
  programs.anyrun = {
    enable = true;
    config = {
      plugins = [
        anyrun.packages.${pkgs.system}.applications
      ];
      width = { fraction = 0.3; };
      hideIcons = false;
      ignoreExclusiveZones = false;
      layer = "overlay";
      hidePluginInfo = true;
      closeOnClick = true;
      showResultsImmediately = true;
      maxEntries = null;
    };
  };
}
