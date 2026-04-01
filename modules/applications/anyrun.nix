{
  flake.modules.homeManager.anyrun = { config, pkgs, ... }: {
    programs.niri.settings.binds."Super+Escape".action = config.lib.niri.actions.spawn "anyrun";
    programs.anyrun = {
      enable = true;

      config = {
        plugins = [
          "${pkgs.anyrun}/lib/libapplications.so"
          "${pkgs.anyrun}/lib/librink.so"
          "${pkgs.anyrun}/lib/libdictionary.so"
          "${pkgs.anyrun}/lib/libnix_run.so"
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
          margin: 0;
          padding: 0;
        }

        window {
          background: transparent;
        }

        text {
          padding: 5px;
        }

        .plugin,
        .main {
          color: @text;
          background-color: @bg;
        }

        .matches {
          color: @text;
          background: @bg;
          box-shadow: none;
          border-radius: 16px;
        }

        .match:selected {
          border: 3px solid @selected;
          background: @bg;
        }

        .match {
          border: 3px solid @bg;
          border-radius: 16px;
        }

        box.main {
          background: @bg;
          border: 2px solid @selected;
          padding: 5px;
          border-radius: 16px
        }
      '';

      extraConfigFiles."dictionary.ron".text = ''
        Config(
          prefix: ":def",
          max_entries: 5,
        )
      '';

      extraConfigFiles."nix-run.ron".text = ''
        Config(
          prefix: ":run",
          allow_unfree = true,
          channel: "nixpkgs-unstable",
          max_entries: 5,
        )
      '';
    };
  };
}
