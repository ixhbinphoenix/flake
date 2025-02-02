{ config, pkgs, lib, user, ... }:
with lib;
{
  imports = [
    ../../modules/scripts.nix
    ../../modules/zsh.nix
    ../../modules/git.nix
    ../../modules/tmux.nix
    ../../modules/nixvim.nix
    ../../modules/helix.nix
  ];

  options.stages.pc-base = {
    enable = mkEnableOption "Base PC home-manager config";
    user = mkOption {
      type = types.nonEmptyStr;
      description = ''
        The username of the home-manager user.
        Should be the main user of the system (UID 1000)
      '';
    };
  };

  config = mkIf config.stages.pc-base.enable {
    home.username = "${config.stages.pc-base.user}";
    home.homeDirectory = "/home/${config.stages.pc-base.user}";

    programs.home-manager.enable = true;

    sops = {
      #gnupg.home = "/home/${user}/.gnupg";
      age.keyFile = "/home/${user}/.config/sops/age/keys.txt";
    };

    catppuccin = {
      btop.enable = config.programs.btop.enable;
      bat.enable = config.programs.bat.enable;
      lsd.enable = config.programs.lsd.enable;
      fzf.enable = config.programs.fzf.enable;
    };

    git = {
      name = "ixhbinphoenix";
      email = "phoenix@ixhby.dev";
      delta = true;
      defaultBranch = "root";

      signing = {
        enable = true;
        key = "3E62370C1D773013";
      };
    };

    programs.btop.enable = true;
    programs.bat.enable = true;
    programs.lsd.enable = true;
    programs.fzf = {
      enable = true;
      enableZshIntegration = true;
    };


    home.packages = with pkgs; [
      xdg-utils
      hyfetch
      onefetch
      ffmpeg
      p7zip
      mediainfo
      websocat
      miniserve
    ];

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}
