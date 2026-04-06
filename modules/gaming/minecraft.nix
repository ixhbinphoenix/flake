{
  flake.modules.homeManager.minecraft = { pkgs, ... }: {
    home.packages = with pkgs; [
      prismlauncher
      openjdk8
      openjdk17
      openjdk21
      openjdk25
    ];
  };
}
