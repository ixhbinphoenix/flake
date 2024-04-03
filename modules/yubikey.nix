{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    yubikey-manager-qt
    yubikey-personalization-gui
    yubico-piv-tool
    yubioath-flutter
  ];

  services.pcscd.enable = true;
}
