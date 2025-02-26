{ config, pkgs, user, ... }:
{
  config = {
    sops.secrets.zipline-upload = {
      sopsFile = ../secrets/zipline-upload.env;
      format = "dotenv";
    };

    home.packages = let
      ils = pkgs.writeShellApplication {
        name = "ils";

        text = ''
          for f in *; do if [ -f "$f" ]; then
            echo "$f"
            kitty +kitten icat "$f"
          fi done
        '';
      };
      nix-gc = pkgs.writeShellApplication {
        name = "nix-gc";

        text = ''
          nix-collect-garbage -d &&
          nix store optimise
        '';
      };
      zipline-upload = pkgs.writeShellApplication {
        name = "zipline-upload";

        runtimeInputs = with pkgs; [ curl jq wl-clipboard libnotify ];

        text = ''
          #shellcheck disable=SC1091
          set -a && source ${config.sops.secrets.zipline-upload.path} && set +a
          curl -H "authorization: $ZIPLINE_TOKEN" https://i.ixhby.dev/api/upload -F file=@/tmp/screenshot.png -H "Content-Type: multipart/form-data" | jq -r '.files[0].url' | tr -d '\n' | wl-copy
          notify-send -h string:x-canonical-private-synchronous:shot-notify -u low "Screenshot uploaded. \
          Link copied to clipboard"
        '';
      };
      screenshot = pkgs.writeShellApplication {
        name = "screenshot";

        runtimeInputs = with pkgs; [ grim slurp libnotify ];

        text = let
          path = "/home/${user}/Pictures/screenshots";
        in ''
          dir=${path}
          time=$(date +%Y-%m%d_%H-%M-%S)
          file="''${time}.png"

          shootarea() {
            grim -g "''$(slurp -c cba6f7)" - | tee "/tmp/screenshot.png" | wl-copy
            cp /tmp/screenshot.png "$dir/$file"
          }

          if [ ! -d "$dir" ]; then
            mkdir -p "$dir"
          fi

          if [ "$1" == "--area" ]; then
            shootarea
            notify-send -h string:x-canonical-private-synchronous:shot-notify -u low "Screenshot saved"
          fi

          if [ "$2" == "--upload" ]; then
            ${zipline-upload}/bin/zipline-upload
          fi

          exit 0
        '';
      };
      notify-pipe = pkgs.writeShellApplication {
        name = "notify-pipe";

        runtimeInputs = with pkgs; [ libnotify ];

        text = ''
          read -r notification
          notify-send "$notification" "$@"
        '';
      };
      set_wallpaper = pkgs.writeShellApplication {
        name = "set_wallpaper";

        runtimeInputs = with pkgs; [ lsd ];

        text = ''
          set_wallpaper() {
            swww img --transition-type top --transition-step 20 --transition-fps 60 "$1"
          }

          if [ -f "$1" ]; then
            set_wallpaper "$1"
          elif [ -f "$HOME/Pictures/wallpapers/$1" ]; then
            set_wallpaper "$HOME/Pictures/wallpapers/$1"
          else
            lsd -la "$HOME/Pictures/wallpapers/"
          fi
        '';
      };
      random_wallpaper = pkgs.writeShellApplication {
        name = "random_wallpaper";

        text = ''
          set_wallpaper() {
            swww img --transition-type top --transition-step 20 --transition-fps 60 "$1"
          }

          PICTURE=$(find "$HOME/Pictures/wallpapers/" -type f | shuf -n 1)
          set_wallpaper "$PICTURE"
        '';
      };
      switch-gpg-yubikey = pkgs.writeShellApplication {
        name = "switch-gpg-yubikey";

        text = ''
          gpg-connect-agent "scd serialno" "learn --force" /bye
        '';
      };
      set_animated_wallpaper = pkgs.writeShellApplication {
        name = "set_animated_wallpaper";

        runtimeInputs = with pkgs; [ mpvpaper lsd ];

        text = ''
          set_animated_wallpaper_on_output() {
            mpvpaper -pf -o "no-audio loop" "$2" "$1"
          }

          set_animated_wallpaper() {
            swww kill 2>/dev/null
            pkill mpvpaper
            set_animated_wallpaper_on_output "$1" DP-1
            set_animated_wallpaper_on_output "$1" DP-2
            set_animated_wallpaper_on_output "$1" HDMI-A-1
          }

          if [ -f "$1" ]; then
            set_animated_wallpaper "$1"
          elif [ -f "$HOME/Pictures/wallpapers/animated/$1" ]; then
            set_animated_wallpaper "$HOME/Pictures/wallpapers/animated/$1"
          else
            lsd -la "$HOME/Pictures/wallpapers/animated/"
          fi
        '';
      };
      random_animated_wallpaper = pkgs.writeShellApplication {
        name = "random_animated_wallpaper";

        text = ''
          WALLPAPER=$(find "$HOME/Pictures/wallpapers/animated/" -type f | shuf -n 2)

          ${set_animated_wallpaper}/bin/set_animated_wallpaper "$WALLPAPER"
        '';
      };
    in [
      ils
      nix-gc
      zipline-upload
      screenshot
      notify-pipe
      set_wallpaper
      random_wallpaper
      set_animated_wallpaper
      random_animated_wallpaper
    ];
  };
}
