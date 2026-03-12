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

      sessionVariables = {
        GPG_TTY = "$TTY"; # TODO: Check out where this could be better suited
        SSH_AUTH_SOCK = "$(gpgconf --list-dirs agent-ssh-socket)"; # TODO: Check out where this could be better suited
      };

      shellAliases = {
        icat = "kitten icat"; # TODO: Put in kitty module
        ":q" = "exit";
        qq = "exit";
        v = "nvim"; # TODO: Put in nvim module
        "+x" = "chmod +x";
      };
    };
  };

  flake.modules.homeManager.catppuccin = {
    catppuccin.zsh-syntax-highlighting.enable = true;
  };
}
