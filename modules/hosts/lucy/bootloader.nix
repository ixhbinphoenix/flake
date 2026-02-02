{ inputs, ... }: {
  flake.modules.nixos.lucy = {
    imports = with inputs.self.modules.nixos; [
      grub
    ];

    boot.loader.grub.device = "/dev/vda";
  };
}
