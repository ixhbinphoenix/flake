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
          {
            home.stateVersion = "25.11";
          }
          catppuccin
          librewolf
          shell
          git
          (self.factory.git-user-hm {
            name = "ixhbinphoenix";
            email = "phoenix@ixhby.dev";
            key = "3E62370C1D773013";
          })
          niri
          nixvim
          celeste
          minecraft
          obs
          misc-applications
        ];
      };
    }
  ];
}
