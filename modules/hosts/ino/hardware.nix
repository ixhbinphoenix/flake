{ inputs, ...}: {
  flake.modules.nixos.ino = {
    imports = with inputs.self.modules.nixos; [
      qemu-guest
    ];

    boot.kernelModules = [];
    boot.extraModulePackages = [];

    boot.initrd.availableKernelModules = [ "ata_piix" "uhci_hcd" "xen_blkfront" "vmw_pvscsi" ];
    boot.initrd.kernelModules = [ "nvme" ];
  };
}
