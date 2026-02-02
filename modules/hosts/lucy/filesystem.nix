{ ... }: {
  flake.modules.nixos.lucy = {
    fileSystems = {
      "/" = {
        device = "/dev/disk/by-uuid/048832f8-0461-4393-ab3f-f854738477f0";
        fsType = "ext4";
      };
    };

    swapDevices = [
      {
        device = "/dev/disk/by-uuid/b0139b1f-a039-4430-839c-11c3b4cb0f1c";
      }
    ];
  };
}
