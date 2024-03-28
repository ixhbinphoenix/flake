{ config, lib, pkgs, inputs, user, nur, ... }:
{
  imports = [
    ../modules/desktop/greetd.nix
  ];
  fonts = {
    packages = with pkgs; [
      iosevka
      (nerdfonts.override { fonts = [ "Iosevka" "IosevkaTerm" "JetBrainsMono" ]; })
      source-code-pro
      font-awesome
      noto-fonts-emoji
      ipafont
      monocraft
    ];
    fontconfig.defaultFonts = {
      emoji = [ "Iosevka Nerd Font" "Noto Emoji" "Font Awesome" ];
      monospace = [ "Iosevka Term Nerd Font" "Source Code Pro" ];
      sansSerif = [ "Iosevka Nerd Font" "IPAFont" ];
    };
  };

  hardware.opengl = {
    enable = true;
    driSupport32Bit = true;
  };

  programs.dconf.enable = true;

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
     extraGroups = [ "wheel" "networkmanager" "input" "video" "docker" ];
     packages = with pkgs; [];
  };

  services.udev.packages = with pkgs; [ yubikey-personalization wooting-udev-rules  ];

  services.pcscd.enable = true;

  security.pam.services = {
    login.u2fAuth = true;
    sudo.u2fAuth = true;
  };

  security.pam.u2f = {
    enable = true;
    cue = true;
    control = "required";
  };

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryPackage = pkgs.pinentry-curses;
    # pinentryFlavor = "curses";
  };

  programs.kdeconnect.enable = true;

  services.dbus.enable = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 51413 22000 3000 ];
  networking.firewall.allowedUDPPorts = [ 22000 3000 ];
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
  
  xdg = {
    portal = {
      enable = true;
      wlr.enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk pkgs.xdg-desktop-portal-hyprland ];
      config.common.default = "*";
    };
    mime = {
      enable = true;

      defaultApplications = {
        "text/html" = "librewolf.desktop";
        "x-scheme-handler/http" = "librewolf.desktop";
        "x-scheme-handler/about" = "librewolf.desktop";
        "x-scheme-handler/unknown" = "librewolf.desktop";
      };
    };
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
      auto-optimise-store = true; # Optimize Symlinks
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

  environment = {
    variables = {
      # Setting all these env variables in the default config might be a problem later, but the word 'later' in that scentence makes me not care about it
      # Well here we are
      TERMINAL = "kitty";
      EDITOR = "nvim";
      VISUAL = "nvim";
      BROWSER = "librewolf";
      XDG_CURRENT_DESKTOP = "hyprland";
      MOZ_ENABLE_WAYLAND = "1";
      MOZ_DBUS_REMOTE = "1";
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
      wayland
      egl-wayland
      glib
      grim
      slurp
      wl-clipboard
      wlprop
      file
      jq
      hyfetch
      pcscliteWithPolkit.out # Workaround for #280826
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

