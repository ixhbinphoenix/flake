{
  flake.modules.nixos.gpg = { pkgs, ... }: {
    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      pinentryPackage = pkgs.pinentry-gtk2;
    };

    environment.systemPackages = with pkgs; [
      pinentry-all
    ];
  };
}
