{pkgs, ...}:
{
  home.file.".zshrc" = {
    source = ./.zshrc;
    recursive = true;
  };
  home.file.".p10k.zsh" = {
    source = ./.p10k.zsh;
    recursive = true;
  };
}
