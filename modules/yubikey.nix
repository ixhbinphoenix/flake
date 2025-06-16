{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    yubico-piv-tool
    yubioath-flutter
  ];

  services.pcscd.enable = true;

  services.udev.packages = with pkgs; [ yubikey-personalization ];
}
