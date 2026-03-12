{
  flake.modules.homeManager.lsd = {
    programs.lsd.enable = true;
  };

  flake.modules.homeManager.catppuccin = {
    catppuccin.lsd.enable = true;
  };

  flake.modules.homeManager.zsh = {pkgs, ...}: {
    programs.zsh.shellAliases.ls = pkgs.lib.mkForce "lsd --color=auto -la";
  };
}
