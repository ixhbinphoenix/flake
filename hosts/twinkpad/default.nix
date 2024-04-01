{ config, lib, pkgs, inputs, user, nur, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";

  networking.hostName = "twinkpad";
  networking.hosts = {
    "192.168.172.69" = ["snowflake"];
  };

  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Berlin";

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_TIME = "de_DE.UTF-8";
      LC_MONETARY = "de_DE.UTF-8";
    };
  };

  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  programs.zsh.enable = true;
  environment.shells = with pkgs; [ zsh ];

  users.users.${user} = {
    isNormalUser = true;
    uid = 1000;
    home = "/home/${user}";
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "networkmanager" "input" "video" ];
    packages = with pkgs; [];
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDiEeAdDWd8RQ0KuRhSZjGSLWJzrWcgwmEdVGCFFKh/lep8uP4sSB3G0a5Ep8Fdgcz7F4tSZ2OkiTNJIAzChw1bNjPHB/JMIycEQ6v9a6Ye6k/j9Ij40Qh0LaWdWqF78+4/GAVLlZjNJau2SsRn/7SN0FG2z/Zq+DBhEYyJAbzYeOlpHwMlR9jh0J/edk2Q2hRrbbn6zp+LFjRuH6iJbxjNiU+NhYeFEZK2+mEal/SzibWcrOl4aDri3eEdxlM8P0OAMM6vA4ARn/4961ZUIlvXH688HpWa5eiez3pIgLinBguOAx9UgDcohYl7HHnCysKPkWad4O3qJnUAJOu1xRmjftBxTaLKWPcDvKQah5JS4l7/Qhm+uTRbpWYAP1hdt9yqDQvv1DZk92pax0KrjB2j8V3visMlVUp8iXQhvUDizN2zOvLDqsalNmnqB1ootI1fzgT+MW3E7br4eSGZlOhK5gCHBzfEqbjf3ygTxfR/Op1HMWc5IJ46sameecy65Bxh/E+Oscv/pqoEinWRrwUq/S/CssySGZQxRcXUhq4f+MubU/dasfa+/ZkdEqlXIIc6xdWQ/7BggzXbJ+gn4v+NaXjShqD+UT9oF+Elahsl2HbdqdUlz4prfc2WjDLFr7bOhhg26GjgXCzOyqkzvl/apPkO0Q2vySgqj/qKLGI3eQ== cardno:25_359_011"
    ];
  };
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJHbF9GubrXMGxsFbOoyG7qY8dTIpOKU52oPT9lFYcRV phoenix"
  ];

  services.udev.packages = with pkgs; [ yubikey-personalization wooting-udev-rules ];

  services.pcscd.enable = true;

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryPackage = pkgs.pinentry-curses;
  };

  services.dbus.enable = true;

  networking.firewall.enable = true;

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = true;
    settings.KbdInteractiveAuthentication = true;
  };

  security.polkit.enable = true;

  security.doas = {
    enable = true;
    extraRules = [
      {
        users = [ "${user}" ];
        persist = true;
      }
      {
        groups = [ "wheel" ];
        persist = true;
      }
    ];
  };
  security.sudo.enable = false;

 
  services.pipewire = {
    enable = true;
    audio.enable = true;

    alsa.enable = true;
    jack.enable = true;
    pulse.enable = true;

    wireplumber.enable = true;
  };


  environment = {
    variables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
    systemPackages = with pkgs; [
      (writeScriptBin "sudo" ''exec doas "$@"'')
      git
      killall
      usbutils
      pciutils
      wget
      mesa
      xdg-utils
      libnotify
      croc
      file
      jq
      hyfetch
      pcscliteWithPolkit.out
    ];
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
      packageOverrides = super: let self = super.pkgs; in {
      };
    };
    overlays = [ inputs.nur.overlay ];
  };

  nix = {
    settings = {
      auto-optimise-store = true;
      trusted-users = [ "root" user ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    package = pkgs.nixFlakes;
    registry.nixpkgs.flake = inputs.nixpkgs;
    extraOptions = "experimental-features = nix-command flakes";
  };


  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "23.11"; # Did you read the comment?

}

