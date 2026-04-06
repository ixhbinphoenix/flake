{ inputs, ... }: {
  flake.modules.nixos.ino = {
    imports = with inputs.self.modules.nixos; [
      grub
    ];

    boot.loader.grub.device = "/dev/sda";
  };
}
