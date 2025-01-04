{ config, pkgs, lib, ...}:
with lib;
{
  imports = [];

  options.git = {
    name = mkOption {
      type = types.nonEmptyStr;
      description = ''
        Username to be used for commits
      '';
    };
    email = mkOption {
      type = types.nonEmptyStr;
      description = ''
        Commit email
      '';
    };
    
    signing = {
      enable = mkEnableOption "GPG Commit Signing";
      key = mkOption {
        type = types.nonEmptyStr;
        description = ''
          GPG Key ID to be used for signing
        '';
      };
    };
    
    defaultBranch = mkOption {
      type = types.nonEmptyStr;
      default = "root";
      description = ''
        Default branch of a newly initialized git repository
      '';
    };

    delta = mkEnableOption "Use delta for git diffs";
  };

  config = let
    cfg = config.git;
  in {
    catppuccin.delta.enable = cfg.delta;
    programs.git = {
      enable = true;
      lfs.enable = true;
      delta = mkIf cfg.delta {
        enable = true;
      };
      signing = mkIf cfg.signing.enable {
        signByDefault = true;
        key = cfg.signing.key;
      };
      extraConfig = {
        alias = {
          staash = "stash --all";
        };
        user = {
          name = cfg.name;
          email = cfg.email;
        };
        init = {
          defaultBranch = cfg.defaultBranch;
        };
        push.autoSetupRemote = true;
        pull = {
          rebase = true;
        };
      };
    };
  };
}
