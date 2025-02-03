# This will be a problem
{ inputs, pkgs, osConfig, ...}: {
  imports = [];

  options = {};

  config = {
    programs.anyrun = {
      enable = true;
      config = {
        plugins = [
          inputs.anyrun.packages.${pkgs.system}.applications
          inputs.anyrun.packages.${pkgs.system}.rink
          inputs.anyrun.packages.${pkgs.system}.dictionary
          inputs.anyrun-nixos-options.packages.${pkgs.system}.default
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
        hm-options = inputs.home-manager.packages.${pkgs.system}.docs-json + "/share/doc/home-manager/options.json";
        options = builtins.toJSON {
          ":nix" = [nixos-options];
          ":hm" = [hm-options];
        };
      in ''
        Config(
            options: ${options},
        )
      '';

      extraConfigFiles."dictionary.ron".text = ''
        Config(
          prefix: ":def",
          max_entries: 5,
        )
      '';
    };
  };
}
