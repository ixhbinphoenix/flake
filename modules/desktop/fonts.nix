{
  flake.modules.nixos.fonts = { pkgs, ... }: {
    fonts = {
      packages = with pkgs; [
        nur.repos.suhr.iosevka-term
        iosevka
        nerd-fonts.iosevka
        nerd-fonts.iosevka-term
        source-code-pro
        font-awesome
        noto-fonts-color-emoji
        ipafont
      ];
      fontconfig.defaultFonts = {
        emoji = [ "Iosevka Nerd Font" "Noto Emoji" "Font Awesome" ];
        monospace = [ "Iosevka Term Nerd Font" "Source Code Pro" ];
        sansSerif = [ "Iosevka Nerd Font" "IPAFont" ];
      };
    };
  };
}
