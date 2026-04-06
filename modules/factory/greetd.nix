{
  config.flake.factory.greetd-nixos = cmd: { pkgs, ... }: {
    services.greetd = {
      enable = true;
      settings = {
        terminal = {
          vt = 1;
        };
        default_session = {
          command = "${pkgs.greetd}/bin/agreety --cmd ${cmd}";
        };
      };
    };
  };
}
