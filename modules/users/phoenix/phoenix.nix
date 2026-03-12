{ self, lib, ... }: {
  flake.modules = lib.mkMerge [
    (self.factory.user "phoenix" true)
    {
      nixos.phoenix = {
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
