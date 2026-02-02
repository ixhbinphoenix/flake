{
  flake.modules.nixos.ramlethal = {
    fileSystems = {
      "/" = {
        device = "/dev/disk/by-uuid/58e0f6ed-c6a6-4bb2-b9f7-43281b80dfeb";
        fsType = "ext4";
      };
      "/boot" = {
        device = "/dev/disk/by-uuid/930A-64E6";
        fsType = "vfat";
        options = [ "fmask=0022" "dmask=0022" ];
      };
    };

    boot.initrd.luks.devices = {
      "nixos".device = "/dev/disk/by-uuid/3ee26202-4744-41eb-8234-d86efd1cbac8";
    };
  };
}
