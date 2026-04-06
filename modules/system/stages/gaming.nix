{ self, ... }: {
  flake.modules.nixos.gaming-nixos = {
    imports = with self.modules.nixos; [
      default-pc
      steam
    ];
  };
}
