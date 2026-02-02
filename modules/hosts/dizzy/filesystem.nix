{ ... }: {
  flake.modules.nixos.dizzy = {
    fileSystems = {
      "/" = {
        device = "/dev/disk/by-uuid/f01bd738-4096-459d-8e35-83160ec4e6d3";
        fsType = "ext4";
      };
      "/boot" = {
        device = "/dev/disk/by-uuid/3FB7-06B4";
        fsType = "vfat";
      };
      "/mnt/hdd1" = {
        device = "/dev/disk/by-uuid/a7bb31e2-6a57-4857-bcfa-ac936312b1b9";
        fsType = "ext4";
      };
      "/mnt/hdd0" = {
        device = "/dev/disk/by-uuid/63912162-7dc5-4ce7-92e7-5859bba9b9e9";
        fsType = "ext4";
      };
      "/mnt/hyperspeed" = {
        device = "/dev/disk/by-uuid/102e4512-9f47-49a2-a1dc-639a703a754b";
        fsType = "ext4";
      };
    };

    boot.initrd.luks.devices = {
      "root-enc".device = "/dev/disk/by-uuid/43f3066d-fa8a-4ef3-a9e6-54da9f30b63e";
      "hdd1-enc".device = "/dev/disk/by-uuid/dc507908-433b-4e58-8ba3-f3fd6e90cd48";
      "hdd0-enc".device = "/dev/disk/by-uuid/e637c1b4-cbce-4b03-9708-79ff43024cc0";
      "hyperspeed-enc".device = "/dev/disk/by-uuid/290f754c-d0a1-41a0-bf8d-75753692c238";
    };

    swapDevices = [
      {
        device = "/dev/disk/by-uuid/10bd7af8-55a4-4956-8846-1c5d93330014";
      }
    ];
  };
}
