{
  flake.modules.nixos.zsh = { pkgs, ... }: {
    environment.shells = with pkgs; [ zsh ];
    programs.zsh.enable = true;
  };

  flake.modules.homeManager.zsh = {
    programs.zsh = {
      enable = true;

      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      sessionVariables = { # TODO: GPG
        GPG_TTY = "$TTY";
        SSH_AUTH_SOCK = "$(gpgconf --list-dirs agent-ssh-socket)";
      };

      shellAliases = {
        icat = "kitten icat";
        ":q" = "exit";
        qq = "exit";
        v = "nvim";
        "+x" = "chmod +x";
      };
    };
  };

  flake.modules.homeManager.catppuccin = {
    catppuccin.zsh-syntax-highlighting.enable = true;
  };
}
