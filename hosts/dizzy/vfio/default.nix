{config, pkgs, user, ...}:
{
  boot.kernelParams = [ "amd_iommu=on" "iommu=pt" ];
  boot.kernelModules = [ "kvm-amd" "vfio-pci" ];

  users.users.${user} = {
    extraGroups = [ "livirtd" ];
  };

  virtualisation.libvirtd = {
    enable = true;
    onBoot = "ignore";
    onShutdown = "shutdown";
    qemu = {
      #ovmf.enable = true;
      runAsRoot = true;
    };
  };

  systemd.services.libvirtd = {
    path = let
      env = pkgs.buildEnv {
        name = "qemu-hook-env";
        paths = with pkgs; [
          bash
          libvirt
          kmod
          systemd
          ripgrep
          sd
        ];
      };
    in
    [ env ];

    preStart =
    ''
    mkdir -p /var/lib/libvirt/hooks/qemu.d/win10/prepare/begin
    mkdir -p /var/lib/libvirt/hooks/qemu.d/win10/release/end
    mkdir -p /var/lib/libvirt/vgabios

    ln -sf /home/${user}/flake/hosts/dizzy/vfio/qemu /var/lib/libvirt/hooks/qemu
    ln -sf /home/${user}/flake/hosts/dizzy/vfio/kvm.conf /var/lib/libvirt/hooks/kvm.conf
    ln -sf /home/${user}/flake/hosts/dizzy/vfio/start.sh /var/lib/libvirt/hooks/qemu.d/win10/prepare/begin/start.sh
    ln -sf /home/${user}/flake/hosts/dizzy/vfio/stop.sh /var/lib/libvirt/hooks/qemu.d/win10/release/end/stop.sh
    ln -sf /home/${user}/flake/hosts/dizzy/vfio/vbios.rom /var/lib/libvirt/vgabios/vbios.rom

    chmod +x /var/lib/libvirt/hooks/qemu
    chmod +x /var/lib/libvirt/hooks/kvm.conf
    chmod +x /var/lib/libvirt/hooks/qemu.d/win10/prepare/begin/start.sh
    chmod +x /var/lib/libvirt/hooks/qemu.d/win10/release/end/stop.sh

    chmod -R 660 /var/lib/libvirt/vgabios/vbios.rom
    '';
  };

  environment.systemPackages = with pkgs; [
    virt-manager
    libguestfs
  ];
}
