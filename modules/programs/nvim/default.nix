{pkgs, ...}:
{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    withNodeJs = true;
    withPython3 = true;
    withRuby = true;
    extraLuaConfig = ''
    require("ixhbinphoenix")
    '';
  };
  
  home.file.".config/nvim/lua" = {
    source = ./lua;
    recursive = true;
  };
  home.file.".config/nvim/after" = {
    source = ./after;
    recursive = true;
  };
}
