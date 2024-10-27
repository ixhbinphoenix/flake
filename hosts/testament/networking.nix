{ lib, ... }: {
  # This file was populated at runtime with the networking
  # details gathered from the active system.
  networking = {
    nameservers = [ "1.1.1.1"
 "8.8.8.8"
 ];
    defaultGateway = "169.254.255.1";
    defaultGateway6 = {
      address = "fe80::1";
      interface = "eth0";
    };
    dhcpcd.enable = false;
    usePredictableInterfaceNames = lib.mkForce false;
    interfaces = {
      eth0 = {
        ipv4.addresses = [
          { address="92.113.144.20"; prefixLength=32; }
        ];
        ipv6.addresses = [
          { address="2a0f:f01:206:15::"; prefixLength=124; }
{ address="fe80::216:3eff:fe95:a3ac"; prefixLength=64; }
        ];
        ipv4.routes = [ { address = "169.254.255.1"; prefixLength = 32; } ];
        ipv6.routes = [ { address = "fe80::1"; prefixLength = 128; } ];
      };
      
    };
  };
  services.udev.extraRules = ''
    ATTR{address}=="00:16:3e:95:a3:ac", NAME="eth0"
    
  '';
}
