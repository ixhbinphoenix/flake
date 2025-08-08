{ config, pkgs, lib, ... }:
with lib;
{
  imports = [
    ../../modules/wlogout.nix
    ../../modules/anyrun.nix
    ../../modules/kitty.nix
    ../../modules/niri
  ];

  options.stages.wayland = {
    enable = mkEnableOption "Wayland home-manager config";
  };

  config = mkIf config.stages.wayland.enable {
    assertions = [
      {
        assertion = config.stages.pc-base.enable;
        message = ''
          Stage Wayland depends on the pc-base Stage
        '';
      }
    ];

    #hyprland.enable = true;
    niri.enable = true;

    catppuccin = {
      enable = true;
      accent = "mauve"; # default options, let's fucking go
      flavor = "mocha";

      # TODO: catppuccin/nix#552
      mako.enable = false;

      cursors = {
        enable = true;
        accent = "dark";
      };

      gtk = {
        enable = true;
        icon.enable = true;
      };

      mpv.enable = config.programs.mpv.enable;
    };

    programs.mpv = {
      enable = true;
    };

    services.emacs = {
      enable = true;
      package = pkgs.emacs-gtk;
    };

    home.packages = with pkgs; [
      pavucontrol
      keepassxc
      ani-cli
      yt-dlp
      prismlauncher
      everest-mons # nix package for olympus when
      tenacity
      hyprpicker
      gpodder
      qbittorrent
      # TODO: https://github.com/NixOS/nixpkgs/issues/377206
      #trackma-qt
      vesktop
      tauon
      signal-desktop-bin
      gajim
      gimp
      mpvpaper
      pcmanfm
      picard
      lrcget
      obsidian
      swww
      waypaper
      thunderbird
      cava
      emacs-gtk
      texliveFull
    ];

    services.syncthing.enable = true;
    services.arrpc.enable = true;
    services.network-manager-applet.enable = true;

    programs.librewolf = {
      enable = true;
      languagePacks = [
        "en-US"
        "de"
      ];
      settings = {
        "webgl.disabled" = false;
        "privacy.resistFingerprinting" = false;
        "browser.ml.enable" = false;
        "middlemouse.paste" = false;
        "general.autoScroll" = true;
      };

      profiles.default = {
        id = 0;
        isDefault = true;

        extensions = {
          force = true;

          packages = with pkgs.nur.repos.rycee.firefox-addons; [
            adaptive-tab-bar-colour
            blocktube
            buster-captcha-solver
            canvasblocker
            catppuccin-mocha-mauve
            consent-o-matic
            container-tab-groups
            containerise
            darkreader
            dearrow
            gnu_terry_pratchett
            keepassxc-browser
            libredirect
            nixpkgs-pr-tracker
            react-devtools
            return-youtube-dislikes
            sponsorblock
            stylus
            tridactyl
            ublock-origin
            video-downloadhelper
            violentmonkey
            web-scrobbler
          ];

          settings = {
            "jid1-HGPgB0x6133Hig@jetpack" = { # GNU terry pratchett
              permissions = [
                "webRequest" "tabs" "alarms"
                "<all_urls>"
              ];
            };
            "{e58d3966-3d76-4cd9-8552-1582fbc800c1}" = { # Buster: Captcha Solver
              permissions = [
                "storage" "notifications" "webRequest" "webRequestBlocking" "webNavigation" "nativeMessaging"
                "<all_urls>" "https://google.com/recaptcha/api2/bframe*" "https://www.google.com/recaptcha/api2/bframe*" "https://google.com/recaptcha/enterprise/bframe*" "https://www.google.com/recaptcha/enterprise/bframe*" "https://recaptcha.net/recaptcha/api2/bframe*" "https://www.recaptcha.net/recaptcha/api2/bframe*" "https://recaptcha.net/recaptcha/enterprise/bframe*" "https://www.recaptcha.net/recaptcha/enterprise/bframe*" "http://127.0.0.1/buster/setup?session=*"
              ];
            };
            "{799c0914-748b-41df-a25c-22d008f9e83f}" = { # Web Scrobbler
              permissions = [
                "storage" "contextMenus" "notifications" "scripting"
                "<all_urls>"
              ];
            };
            "{762f9885-5a13-4abd-9c77-433dcd38b8fd}" = { # Return Youtube Dislike
              permissions = [
                "activeTab" "storage"
                "*://*.youtube.com/*" "*://returnyoutubedislikeapi.com/*"
              ];
            };
            "{58204f8b-01c2-4bbc-98f8-9a90458fd9ef}" = { # BlockTube
              permissions = [
                "storage" "unlimitedStorage"
                "https://www.youtube.com/*" "https://m.youtube.com/*"
              ];
            };
            "tridactyl.vim@cmcaine.co.uk" = { # tridactyl
              permissions = [
                "activeTab" "bookmarks" "browsingData" "contextMenus" "contextualIdentities" "cookies" "clipboardWrite" "clipboardRead" "downloads" "find" "history" "search" "sessions" "storage" "tabHide" "tabs" "topSites" "management" "nativeMessaging" "webNavigation" "webRequest" "webRequestBlocking" "proxy"
                "<all_urls>"
              ];
            };
            "{7a7a4a92-a2a0-41d1-9fd7-1e92480d612d}" = { # Stylus
              permissions = [
                "alarms" "contextMenus" "storage" "tabs" "unlimitedStorage" "webNavigation" "webRequest" "webRequestBlocking"
                "<all_urls>" "https://userstyles.org/*"
              ];
            };
            "{aecec67f-0d10-4fa7-b7c7-609a2db280cf}" = { # Violentmonkey
              permissions = [
                "tabs" "webRequest" "webRequestBlocking" "notifications" "storage" "unlimitedStorage" "clipboardWrite" "contextMenus" "cookies"
                "<all_urls>"
              ];
            };
            "gdpr@cavi.au.dk" = { # Consent-O-Matic
              permissions = [
                "activeTab" "tabs" "storage"
                "<all_urls>"
              ];
            };
            "7esoorv3@alefvanoon.anonaddy.me" = { # LibRedirect
              permissions = [
                "webRequest" "webRequestBlocking" "storage" "clipboardWrite" "contextMenus"
                "<all_urls>"
              ];
            };
            "deArrow@ajay.app" = { # DeArrow
              permissions = [
                "storage" "unlimitedStorage" "alarms" "scripting"
                "https://sponsor.ajay.app/*" "https://dearrow-thumb.ajay.app/*" "https://*.googlevideo.com/*" "https://*.youtube.com/*" "https://www.youtube-nocookie.com/embed/*"
              ];
            };
            "{b9db16a4-6edc-47ec-a1f4-b86292ed211d}" = { # Video DownloadHelper
              permissions = [
                "nativeMessaging" "contextMenus" "downloads" "menus" "notifications" "scripting" "storage" "tabs" "webNavigation" "webRequest" "webRequestBlocking"
                "<all_urls>" "*://*.downloadhelper.net/*" "*://*.downloadhelper.net/changelog/*" "*://*.downloadhelper.net/debugger"
              ];
            };
            "keepassxc-browser@keepassxc.org" = { # KeePassXC-Browser
              permissions = [
                "activeTab" "clipboardWrite" "contextMenus" "cookies" "nativeMessaging" "notifications" "storage" "tabs" "webNavigation" "webRequest" "webRequestBlocking"
                "https://*/*" "http://*/*" "https://api.github.com/" "<all_urls>"
              ];
            };
            "uBlock0@raymondhill.net" = { # uBlock Origin
              permissions = [
                "alarms" "dns" "menus" "privacy" "storage" "tabs" "unlimitedStorage" "webNavigation" "webRequest" "webRequestBlocking"
                "<all_urls>" "http://*/*" "https://*/*" "file://*/*" "https://easylist.to/*" "https://*.fanboy.co.nz/*" "https://filterlists.com/*" "https://forums.lanik.us/*" "https://github.com/*" "https://*.github.io/*" "https://github.com/uBlockOrigin/*" "https://ublockorigin.github.io/*" "https://*.reddit.com/r/uBlockOrigin/*"
              ];
            };
            "@react-devtools" = { # react devtools
              permissions = [
                "scripting" "storage" "tabs" "clipboardWrite" "devtools"
                "<all_urls>"
              ];
            };
            "ATBC@EasonWong" = { # Adaptive Tab Bar Colour
              permissions = [
                "tabs" "theme" "storage" "browserSettings" "management"
                "<all_urls>"
              ];
            };
            "sponsorBlocker@ajay.app" = { # SponsorBlock
              permissions = [
                "storage" "scripting"
                "https://sponsor.ajay.app/*" "https://*.youtube.com/*" "https://www.youtube-nocookie.com/embed/*"
              ];
            };
            "addon@darkreader.org" = { # darkreader
              permissions = [
                "alarms" "contextMenus" "storage" "tabs" "theme"
                "<all_urls>"
              ];
            };
          };
        };
      };
    };

    programs.chromium = {
      enable = true;
      package = pkgs.ungoogled-chromium;
      dictionaries = [
        pkgs.hunspellDictsChromium.en_US
        pkgs.hunspellDictsChromium.de_DE
      ];
      extensions = [
        "ddkjiahejlhfcafbddmgiahcphecmpfh" # ublock origin lite
        "mnjggcdmjocbbbhaepdhchncahnbgone" # sponsorblock
        "eimadpbcbfnmbkopoojfekhnkhdbieeh" # dark reader
        "enamippconapkdmgfgjchkhakpfinmaj" # dearrow
        "dbepggeogbaibhgnhhndojpepiihcmeb" # vimium
        "mpbjkejclgfgadiemmefgebjfooflfhl" # buster
        "mdjildafknihdffpkfmmpnpoiajfjnjd" # consent-o-matic
        "oboonakemofpalcgghocfoadofidjkkk" # KeePassXC-Browser
      ];
    };
  };
}
