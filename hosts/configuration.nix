{ config, lib, pkgs, inputs, user, ... }:
{
  fonts.fonts = with pkgs; [
    (nerdfonts.override { fonts = [ "Iosevka" "JetBrainsMono" ]; })
    source-code-pro
    iosevka
  ];

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
     extraGroups = [ "wheel" "networkmanager" "input" "video" ]; # Enable ‘sudo’ for the user.
     packages = with pkgs; [];
  };

  programs.gnupg.agent = {
    enable = true;
    pinentryFlavor = "curses";
  };

  programs.ssh.startAgent = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 22000 ];
  networking.firewall.allowedUDPPorts = [ 22000 ];
  networking.firewall.enable = true;

  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Polkit
  security.polkit.enable = true;

  # Doas instead of sudo
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

  # Enable sound.
  services.pipewire = {
    enable = true;
    audio.enable = true;

    alsa.enable = true;
    jack.enable = true;
    pulse.enable = true;

    wireplumber.enable = true;
  };

  nixpkgs.config.allowUnfree = true;

  nix = {
    settings = {
      auto-optimise-store = true; # Optimize Symlinks
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

  environment = {
    variables = {
      TERMINAL = "kitty";
      EDITOR = "nvim";
      VISUAL = "nvim";
      XDG_CURRENT_DESKTOP = "sway";
      MOZ_ENABLE_WAYLAND = "1";
      SDL_VIDEODRIVER = "wayland";
      QT_QPA_PLATFORM = "wayland";
      _JAVA_AWT_WM_NONREPARENTING = "1";
    };
    systemPackages = with pkgs; [
      (writeScriptBin "sudo" ''exec doas "$@"'')
      git
      gcc
      rustup
      nodejs
      killall
      usbutils
      pciutils
      wget
      mesa
      xdg-utils
      libnotify
      pinentry-curses
      croc
      dunst
    ];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}

