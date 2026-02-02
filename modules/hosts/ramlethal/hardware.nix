{...}: {
  flake.modules.nixos.ramlethal = {
    boot.kernelModules = [ "kvm-amd" ];
    boot.extraModulePackages = [];

    boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
    boot.initrd.kernelModules = [];

    hardware.cpu.amd.updateMicrocode = true;
  };
}
