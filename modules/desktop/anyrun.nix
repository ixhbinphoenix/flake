{pkgs, osConfig, home-manager, anyrun, anyrun-nixos-options, ...}: {
  programs.anyrun = {
    enable = true;
    config = {
      plugins = [
        anyrun.packages.${pkgs.system}.applications
        anyrun.packages.${pkgs.system}.rink
        anyrun-nixos-options.packages.${pkgs.system}.default
      ];
      width = { fraction = 0.3; };
      height = { absolute = 0; };
      hideIcons = false;
      ignoreExclusiveZones = false;
      layer = "overlay";
      hidePluginInfo = true;
      closeOnClick = true;
      showResultsImmediately = true;
      maxEntries = 10;
    };
    extraCss = ''
      window {
        opacity: 0%;
      }
    '';

    extraConfigFiles."nixos-options.ron".text = let
      nixos-options = osConfig.system.build.manual.optionsJSON + "/share/doc/nixos/options.json";
      hm-options = home-manager.packages.${pkgs.system}.docs-json + "/share/doc/home-manager/options.json";
      options = builtins.toJSON {
        ":nix" = [nixos-options];
        ":hm" = [hm-options];
      };
    in ''
      Config(
        options: ${options},
      )
    '';
  };
}
