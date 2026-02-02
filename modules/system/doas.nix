{
  flake.modules.nixos.doas = { config, pkgs, ... }: {
    security.doas = {
      enable = true;
      extraRules = [
        {
          users = [ config.systemConstants.user ];
          persist = true;
        }
        {
          groups = [ "wheel" ];
          persist = true;
        }
      ];
    };
    security.sudo.enable = true;

    environment.systemPackages = [
      (pkgs.writeScriptBin "sudo" ''exec doas "$@"'')
    ];
  };
}
