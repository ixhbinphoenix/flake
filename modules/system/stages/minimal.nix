{ inputs, ... }: {
  flake.modules.nixos.nixos_minimal = { pkgs, ... }: {
    imports = with inputs.self.modules.nixos; [
      nix-config
      lix
      localization
      doas
      shell
      sops
    ];

    console = {
      font = "Lat2-Terminus16";
      keyMap = "us";
    };

    environment.systemPackages = with pkgs; [
      git
    ];
  };
}
