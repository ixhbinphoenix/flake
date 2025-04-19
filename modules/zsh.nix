{pkgs, ...}:
{
  imports = [];

  options = {};

  config = {
    programs.zsh = {
      enable = true;

      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      sessionVariables = {
        GPG_TTY = "$TTY";
        SSH_AUTH_SOCK = "$(gpgconf --list-dirs agent-ssh-socket)";
      };

      shellAliases = {
        ls = "lsd --color=auto -la";
        cat = "bat";
        icat = "kitten icat";
        ":q" = "exit";
        qq = "exit";
        v = "nvim";
        "+x" = "chmod +x";
      };

      initExtra = ''
      eval $(starship init zsh)
      '';
    };

    catppuccin.starship.enable = true;
    catppuccin.zsh-syntax-highlighting.enable = true;

    programs.starship = {
      enable = true;
      settings = {
        format = "[ ](fg:#cdd6f4)$directory$git_branch$git_state$git_status$cmd_duration$status\n$character";
        directory = {
          format = "[ $path]($style) ";
          style = "fg:#89b4fa";
          truncate_to_repo = false;
        };
        git_branch = {
          format = "[$symbol$branch(:remote_branch)]($style)";
          symbol = " ";
          style = "fg:#a6e3a1";
        };
        git_status = {
          format = " $ahead_behind$all_status";
          conflicted = "[=$count](fg:#f38ba8) ";
          untracked = "[?$count](fg:#74c7ec) ";
          stashed = "[*$count](fg:#94e2d5) ";
          modified = "[!$count](fg:#fab387) ";
          staged = "[+$count](fg:#fab387) ";
          renamed = "[~$count](fg:#fab387) ";
          deleted = "[-$count](fg:#f38ba8) ";

          ahead = "[⇡$count](fg:#a6e3a1) ";
          behind = "[⇣$count](fg:#a6e3a1) ";
          diverged = "[⇡$ahead_count⇣$behind_count](fg:#a6e3a1) ";
        };
        status = {
          format = "[$symbol$status]($style)";
          style = "fg:#f38ba8";
          symbol = "";
          recognize_signal_code = false;
          disabled = false;
        };
        cmd_duration = {
          format = "[ $duration]($style)";
          style = "fg:#6c7086";
          min_time = 2000;
        };
      };
    };
  };
}
