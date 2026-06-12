{ inputs, ... }: {
  flake.modules.nixos.music = { ... }: {
    imports = with inputs.self.modules.nixos; [
      musnix
    ];

    musnix = {
      enable = true;
    };
  };

  flake.modules.nixos.VST = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      airwindows
      oxefmsynth
      zam-plugins
      vaporizer2
      uhhyou-plugins
      zlsplitter
      zlcompressor
      zlequalizer
      surge-xt
      lsp-plugins
      vital
      fire
      boops
      talentedhack
      wolf-shaper
      sorcer
      midi-trigger
      vocproc
    ];
  };
}
