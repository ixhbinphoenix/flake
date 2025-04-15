# This will be a problem
{ inputs, pkgs, osConfig, ...}: {
  imports = [];

  options = {};

  config = {
    programs.anyrun = {
      enable = true;
      config = {
        plugins = [
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
        @define-color bg rgb(30, 30, 46);
        @define-color border rgb(30, 30, 46);
        @define-color selected rgb(203, 166, 247);
        @define-color text rgb(205, 214, 244);

        * {
          transition: 200ms ease;
          font-family: "Iosevka Nerd Font";
          caret-color: @text;
        }

        #window {
          background: transparent;
        }

        #plugin,
        #main {
          border: 3px solid @border;
          color: @text;
          background-color: @bg;
        }

        #entry {
          color: @text;
          background: @bg;
          border: 2px solid @selected;
          box-shadow: none;
        }

        #match:selected {
          color: @bg;
          background: @selected;
        }

        #match {
          padding: 3px;
          border-radius: 16px;
        }

        #entry, #plugin:hover {
          border-radius: 16px;
        }

        box#main {
          background: @bg;
          border: 1px solid @border;
          border-radius: 15px;
          padding: 5px;
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
