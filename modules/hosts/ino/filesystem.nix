{ ... }: {
  flake.modules.nixos.ino = {
    fileSystems = {
      "/" = {
        device = "/dev/sda3";
        fsType = "ext4";
      };
    };

    swapDevices = [
      {
        device = "/dev/sda2";
      }
    ];
  };
}
