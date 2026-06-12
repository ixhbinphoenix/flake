{
  flake.modules.homeManager.reaper = { pkgs, ... }: {
    home.packages = with pkgs; [
      reaper
    ];

    xdg.configFile."REAPER" = {
      source = pkgs.symlinkJoin {
        name = "reaper-userplugins";
        paths = with pkgs; [
          reaper-sws-extension
          reaper-reapack-extension
        ];
      };
      recursive = true;
    };
  };
}
