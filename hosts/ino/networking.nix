{ lib, ... }: {
  # This file was populated at runtime with the networking
  # details gathered from the active system.
  networking = {
    nameservers = [ "8.8.8.8"
 "8.8.4.4"
 ];
    defaultGateway = "45.81.233.1";
    defaultGateway6 = {
      address = "";
      interface = "eth0";
    };
    dhcpcd.enable = false;
    usePredictableInterfaceNames = lib.mkForce false;
    interfaces = {
      eth0 = {
        ipv4.addresses = [
          { address="45.81.233.66"; prefixLength=24; }
          { address="45.81.235.222"; prefixLength=24; }
        ];
        ipv6.addresses = [
          { address="fe80::4c65:4ff:fe2f:e02a"; prefixLength=64; }
        ];
        ipv4.routes = [ { address = "45.81.233.1"; prefixLength = 32; } ];
      };
      
    };
  };
  services.udev.extraRules = ''
    ATTR{address}=="4e:65:04:2f:e0:2a", NAME="eth0"
    
  '';
}
