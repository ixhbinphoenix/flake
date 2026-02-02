{ inputs, ...}: {
  flake.modules.nixos.lucy = {
    imports = with inputs.self.modules.nixos; [
      qemu-guest
    ];

    boot.kernelModules = [];
    boot.extraModulePackages = [];

    boot.initrd.availableKernelModules = [ "ata_piix" "uhci_hcd" "virtio_pci" "sr_mod" "virtio_blk" ];
    boot.initrd.kernelModules = [];

    hardware.cpu.amd.updateMicrocode = true;
  };
}
