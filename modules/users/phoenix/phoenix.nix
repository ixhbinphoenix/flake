{ self, lib, ... }: {
  flake.modules = lib.mkMerge [
    (self.factory.user "phoenix" true)
    {
      nixos.phoenix = {
        users.users."phoenix".extraGroups = [
          "networkmanager"
          "input"
        ];
      };

      nixos.doas = {
        security.doas.extraRules = [{
          users = [ "phoenix" ];
          persist = true;
        }];
      };

      nixos.nix-config = {
        nix.settings.trusted-users = [ "phoenix" ];
      };

      homeManager.phoenix = {
        imports = with self.modules.homeManager; [
          catppuccin
          librewolf
        ];
      };
    }
  ];
}
