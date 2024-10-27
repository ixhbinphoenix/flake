{ config, pkgs, lib, inputs, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./networking.nix # generated at runtime by nixos-infect
    
    ./nginx.nix
    ./metrics.nix
  ];

  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = true;

  networking.hostName = "testament";
  networking.domain = "testament.vps.webdock.cloud";

  services.openssh.enable = true;
  users.users.root = {
    extraGroups = [ "podman" ];
    openssh.authorizedKeys.keys = [
      ''ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDiEeAdDWd8RQ0KuRhSZjGSLWJzrWcgwmEdVGCFFKh/lep8uP4sSB3G0a5Ep8Fdgcz7F4tSZ2OkiTNJIAzChw1bNjPHB/JMIycEQ6v9a6Ye6k/j9Ij40Qh0LaWdWqF78+4/GAVLlZjNJau2SsRn/7SN0FG2z/Zq+DBhEYyJAbzYeOlpHwMlR9jh0J/edk2Q2hRrbbn6zp+LFjRuH6iJbxjNiU+NhYeFEZK2+mEal/SzibWcrOl4aDri3eEdxlM8P0OAMM6vA4ARn/4961ZUIlvXH688HpWa5eiez3pIgLinBguOAx9UgDcohYl7HHnCysKPkWad4O3qJnUAJOu1xRmjftBxTaLKWPcDvKQah5JS4l7/Qhm+uTRbpWYAP1hdt9yqDQvv1DZk92pax0KrjB2j8V3visMlVUp8iXQhvUDizN2zOvLDqsalNmnqB1ootI1fzgT+MW3E7br4eSGZlOhK5gCHBzfEqbjf3ygTxfR/Op1HMWc5IJ46sameecy65Bxh/E+Oscv/pqoEinWRrwUq/S/CssySGZQxRcXUhq4f+MubU/dasfa+/ZkdEqlXIIc6xdWQ/7BggzXbJ+gn4v+NaXjShqD+UT9oF+Elahsl2HbdqdUlz4prfc2WjDLFr7bOhhg26GjgXCzOyqkzvl/apPkO0Q2vySgqj/qKLGI3eQ== cardno:25_359_011''
    ];
  };

  virtualisation = {
    podman = {
      enable = true;
      dockerCompat = true;
      dockerSocket.enable = true;

      defaultNetwork.settings.dns_enabled = true;
    };
  };

  networking.firewall.enable = true;
  networking.firewall.allowedUDPPorts = [ 22 ];
  networking.firewall.allowedTCPPorts = [ 22 ];

  environment = {
    systemPackages = with pkgs; [
      git
      wget
      curl
      kitty.terminfo
      podman-tui
      podman-compose
      arion
    ];
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  nix = {
    settings = {
      auto-optimise-store = true;
      trusted-users = [ "root" ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    package = pkgs.nixVersions.stable;
    registry.nixpkgs.flake = inputs.nixpkgs;
    extraOptions = "experimental-features = nix-command flakes";
  };

  # Do not stateVersion unless you know what you're doing etc. etc.
  system.stateVersion = "23.11";
}
