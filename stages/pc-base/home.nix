{ config, pkgs, lib, ... }:
with lib;
{
  imports = [
    ../../modules/scripts
    ../../modules/zsh
    ../../modules/bat.nix
    ../../modules/git.nix
    ../../modules/tmux.nix
    ../../modules/nixvim.nix
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

    home.packages = with pkgs; [
      lsd
      xdg-utils
      hyfetch
      btop
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
