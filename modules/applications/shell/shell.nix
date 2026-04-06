{ inputs, ... }: {
  flake.modules.homeManager.shell = {
    imports = with inputs.self.modules.homeManager; [
      lsd
      bat

      zsh
      starship
    ];
  };

  flake.modules.nixos.shell = { pkgs, ... }: {
    imports = with inputs.self.modules.nixos; [
      zsh
      tmux
    ];
    environment.systemPackages = with pkgs; [
      killall
      usbutils
      pciutils
      wget
      file
      jq
    ];
  };
}
