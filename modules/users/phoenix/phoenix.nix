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

      homeManager.phoenix = { pkgs, ... }: {
        imports = with self.modules.homeManager; [
          {
            home.stateVersion = "25.11";
          }
          sops
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
          anyrun
          nixvim
          celeste
          minecraft
          obs
          misc-applications
        ];

        home.packages = with pkgs; [
          runelite
          reaper
          reaper-sws-extension
          reaper-reapack-extension
        ];
      };
    }
  ];
}
