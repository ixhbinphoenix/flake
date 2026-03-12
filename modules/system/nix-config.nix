{
  flake.modules.nixos.nix-config = {
    nixpkgs.config.allowUnfree = true;

    nix.settings = {
      substituters = [
        "https://cache.nixos.org?priority=10" # i have no clue what priority does but apparently its good
        # included here since pretty much every host uses sth from nix-community, and it's used by too many different packages to be set in their module individually
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];

      experimental-features = [
        "nix-command"
        "flakes"
      ];

      download-buffer-size = 1024 * 1024 * 1024;

      trusted-users = [
        "root"
      ];
    };

    nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };
}
