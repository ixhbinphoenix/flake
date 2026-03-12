{
  flake.modules.homeManager.bat = {
    programs.bat.enable = true;
  };

  flake.modules.homeManager.catppuccin = {
    catppuccin.bat.enable = true;
  };

  flake.modules.homeManager.zsh = {
    programs.zsh.shellAliases.cat = "bat";
  };
}
