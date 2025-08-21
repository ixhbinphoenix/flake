{ config, pkgs, lib, ...}: with lib; {
  imports = [];
  
  options.greetd = {
    cmd = mkOption {
      type = types.nonEmptyStr;
      example = "Hyprland";
      description = ''
        The command that gets executed by greetd. Should be the compositor
      '';
    };
  };

  config = {
    services.greetd = {
      enable = true;
      settings = {
        terminal = {
          vt = 1;
        };
        default_session = {
          command = "${pkgs.greetd}/bin/agreety --cmd ${config.greetd.cmd}";
        };
      };
    };
  };
}
