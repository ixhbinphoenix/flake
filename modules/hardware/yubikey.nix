{ self, ... }: {
  flake.modules.nixos.yubikey = {
    services.pcscd.enable = true;
  };

  flake.modules.nixos.yubikey-desktop = { pkgs, ... }: {
    imports = with self.modules.nixos; [
      yubikey
    ];

    environment.systemPackages = with pkgs; [
      yubico-piv-tool
      yubioath-flutter
    ];

    services.udev.packages = with pkgs; [ yubikey-personalization ];
  };
}
