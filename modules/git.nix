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

  config = {
    programs.git = {
      enable = true;
      delta = mkIf config.git.delta {
        enable = true;
      };
      signing = mkIf config.git.signing.enable {
        signByDefault = true;
        key = config.git.signing.key;
      };
      extraConfig = {
        user = {
          name = config.git.name;
          email = config.git.email;
        };
        init = {
          defaultBranch = config.git.defaultBranch;
        };
        push.autoSetupRemote = true;
      };
    };
  };
}
