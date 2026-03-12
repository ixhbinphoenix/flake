{ inputs, ... }: {
  flake.modules.homeManager.shell = {
    imports = with inputs.self.modules.homeManager; [
      lsd
      bat

      zsh
      starship
    ];
  };
}
