{
  flake.modules.homeManager.obs = { pkgs, ... }: {
    programs.obs-studio = {
      enable = true;
      package = pkgs.obs-studio;
      plugins = with pkgs.obs-studio-plugins; [
        wlrobs
        input-overlay
        obs-vaapi
        obs-gstreamer
        obs-vkcapture
        obs-pipewire-audio-capture
      ];
    };
  };
}
