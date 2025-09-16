{ config, lib, pkgs, ... }: { 
  imports = [
    ./hardware-configuration.nix
    ./networking.nix
    ./services
    ./nginx.nix
  ];

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/vda";

  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_US.UTF-8";

  environment.systemPackages = with pkgs; [
    neovim
    git
    wget
    curl
    kitty.terminfo
  ];

  services.openssh.enable = true;
  users.users.root = {
    openssh.authorizedKeys.keys = [
      ''ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDiEeAdDWd8RQ0KuRhSZjGSLWJzrWcgwmEdVGCFFKh/lep8uP4sSB3G0a5Ep8Fdgcz7F4tSZ2OkiTNJIAzChw1bNjPHB/JMIycEQ6v9a6Ye6k/j9Ij40Qh0LaWdWqF78+4/GAVLlZjNJau2SsRn/7SN0FG2z/Zq+DBhEYyJAbzYeOlpHwMlR9jh0J/edk2Q2hRrbbn6zp+LFjRuH6iJbxjNiU+NhYeFEZK2+mEal/SzibWcrOl4aDri3eEdxlM8P0OAMM6vA4ARn/4961ZUIlvXH688HpWa5eiez3pIgLinBguOAx9UgDcohYl7HHnCysKPkWad4O3qJnUAJOu1xRmjftBxTaLKWPcDvKQah5JS4l7/Qhm+uTRbpWYAP1hdt9yqDQvv1DZk92pax0KrjB2j8V3visMlVUp8iXQhvUDizN2zOvLDqsalNmnqB1ootI1fzgT+MW3E7br4eSGZlOhK5gCHBzfEqbjf3ygTxfR/Op1HMWc5IJ46sameecy65Bxh/E+Oscv/pqoEinWRrwUq/S/CssySGZQxRcXUhq4f+MubU/dasfa+/ZkdEqlXIIc6xdWQ/7BggzXbJ+gn4v+NaXjShqD+UT9oF+Elahsl2HbdqdUlz4prfc2WjDLFr7bOhhg26GjgXCzOyqkzvl/apPkO0Q2vySgqj/qKLGI3eQ== cardno:25_359_011''
    ];
  };

  boot.kernel.sysctl = {
    "vm.swappiness" = 10;
  };

  sops = {
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    defaultSopsFile = ../../secrets/lucy.yaml;
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
    extraOptions = "experimental-features = nix-command flakes";
  };

  system.stateVersion = "25.05";
}

