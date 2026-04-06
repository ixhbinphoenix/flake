{
  flake.modules.nixos.default-graphics = {
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };
  };
}
