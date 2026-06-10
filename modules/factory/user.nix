{ self, ... }: {
  config.flake.factory.user = username: isAdmin: {
    nixos."${username}" = { lib, pkgs, ... }: {
      users.users."${username}" = {
        isNormalUser = true;
        home = "/home/${username}";
        extraGroups = lib.optionals isAdmin [
          "wheel"
        ];
        shell = pkgs.zsh;
      };

      home-manager.users."${username}" = {
        imports = [
          self.modules.homeManager."${username}"
          self.modules.homeManager.nur
          self.modules.homeManager.sops
        ];
      };
    };

    homeManager."${username}" = {
      home.username = "${username}";
    };
  };
}
