{ pkgs, ... }:
{
  imports = [];

  options = {};

  config = {
    services.openssh = {
      enable = true;
      settings.PasswordAuthentication = false;
      settings.KbdInteractiveAuthentication = false;
    };
  };
}
