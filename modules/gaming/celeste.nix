{
  flake.modules.homeManager.celeste = { pkgs, ... }: {
    home.packages = with pkgs; [
      olympus
    ];
  };
}
