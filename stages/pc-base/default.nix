{ config, lib, pkgs, nur, inputs, ... }:
with lib;
{
  imports = [
    ../../modules/yubikey.nix
    ../../modules/wireguard.nix
  ];

  options.stages.pc-base = {
    enable = mkEnableOption "Base PC home-manager config";

    user = mkOption {
      type = types.nonEmptyStr;
      description = ''
        Username of the main user. Will be UID 1000
        Should be the same as the home-manager user
      '';
    };

    hostname = mkOption {
      type = types.nonEmptyStr;
      description = ''
        Hostname of the machine.
        '';
    };

    bootloader = {
      grub = {
        enable = mkEnableOption "GRUB 2 Bootloader";
        device = mkOption {
          type = types.nonEmptyStr;
          description = ''
            Device to install GRUB to 
          '';
        };
      };
      
      systemd-boot = {
        enable = mkEnableOption "systemd-boot Bootloader";
      };

      multi-boot = mkEnableOption "Enables support for multi-booting, including windows";
    };

    localization = {
      timeZone = mkOption {
        type = types.nonEmptyStr;
        default = "Europe/Berlin";
        description = ''
          Timezone of the machine
        '';
      };

      locale = mkOption {
        type = types.nonEmptyStr;
        default = "en_US.UTF-8";
        description = ''
          Locale (Language) of the system
        '';
      };

      #extraLocaleSettings
      LC_TIME = mkOption {
        type = types.nullOr types.nonEmptyStr;
        default = "de_DE.UTF-8";
        description = ''
          Locale for displaying time
        '';
      };
      LC_MONETARY = mkOption {
        type = types.nullOr types.nonEmptyStr;
        default = "de_DE.UTF-8";
        description = ''
          Locale for displaying money
        '';
      };

      keyMap = mkOption {
        type = types.nonEmptyStr;
        default = "us";
        description = ''
          Console keymap
        '';
      };
    };

    sleep = mkOption {
      type = types.bool;
      default = true;
      description = "Enables the sleep/suspend/hibernate/hybrid systemd targets";
    };
  };

  config = mkIf config.stages.pc-base.enable (mkMerge [

    {assertions = [
      {
        assertion = (config.stages.pc-base.bootloader.grub.enable && !config.stages.pc-base.bootloader.systemd-boot.enable) || (!config.stages.pc-base.bootloader.grub.enable || config.stages.pc-base.bootloader.systemd-boot.enable);
        message = ''
          You can only enable one bootloader
        '';
      }
      {
        assertion = config.stages.pc-base.bootloader.grub.enable || config.stages.pc-base.bootloader.systemd-boot.enable;
        message = ''
          This is against config. You've been reported.

          I get that you're excited to be here, but you gotta have a bootloader.
          And this isn't it. You're not in a docker container.
          We're building a laptop or desktop environment here.
          This kind of config isn't the vibe we want.
        '';
      }
    ];}


    (mkIf config.stages.pc-base.bootloader.systemd-boot.enable {
      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;
    })

    (mkIf config.stages.pc-base.bootloader.grub.enable {
      boot.loader.grub.enable = true;
      boot.loader.grub.device = config.stages.pc-base.bootloader.grub.device;

      boot.loader.grub.useOSProber = config.stages.pc-base.bootloader.multi-boot;
    })

    (mkIf config.stages.pc-base.bootloader.multi-boot {
      boot.supportedFilesystems = [ "ntfs" ];
    })

    {
      virtualisation.docker.enable = true;
    
      networking.hostName = config.stages.pc-base.hostname;
    
      networking.networkmanager.enable = true;
      wireguard.enable = true;

      programs.dconf.enable = true;

      services.udev.packages = with pkgs; [ wooting-udev-rules via ];
    
      time.timeZone = config.stages.pc-base.localization.timeZone;
    
      i18n = {
        defaultLocale = config.stages.pc-base.localization.locale;
        extraLocaleSettings = {
          LC_TIME = config.stages.pc-base.localization.LC_TIME;
          LC_MONETARY = config.stages.pc-base.localization.LC_MONETARY;
        };
      };
    
      console = {
        font = "Lat2-Terminus16";
        keyMap = config.stages.pc-base.localization.keyMap;
      };
    
      systemd.targets = mkIf (! config.stages.pc-base.sleep) {
        sleep.enable = false;
        suspend.enable = false;
        hibernate.enable = false;
        hybrid-sleep.enable = false;
      };
    
      programs.zsh.enable = true;
      environment.shells = with pkgs; [ zsh ];
    
      users.users.${config.stages.pc-base.user} = {
        isNormalUser = true;
        uid = 1000;
        home = "/home/${config.stages.pc-base.user}";
        shell = pkgs.zsh;
        extraGroups = [ "wheel" "networkmanager" "input" "docker" ];
      };
    
      programs.gnupg.agent = {
        enable = true;
        enableSSHSupport = true;
        pinentryPackage = pkgs.pinentry-gtk2;
      };
    
      services.dbus.enable = true;
    
      networking.firewall.enable = true;
    
      security.polkit.enable = true;
    
      security.doas = {
        enable = true;
        extraRules = [
        {
          users = [ "${config.stages.pc-base.user}" ];
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
          xdg-utils
          libnotify
          croc
          file
          jq
          hyfetch
          pcscliteWithPolkit.out
          kitty.terminfo
          pinentry-curses
          pkgs.nur.repos.ixhbinphoenix.todoit
          ansible
          pinentry-all
          ripgrep
          comma
          nvd
        ];
      };

      programs.yazi = {
        enable = true;
        settings = {
          yazi = {
            manager = {
              show_hidden = true;
            };
          };
        };
      };
    
      nixpkgs = {
        config = {
          allowUnfree = true;
          packageOverrides = super: let self = super.pkgs; in {
          };
        };
        overlays = [ nur.overlay ];
      };
    
      nix = {
        settings = {
          auto-optimise-store = true;
          trusted-users = [ "root" config.stages.pc-base.user ];
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
    }
  ]);
}
