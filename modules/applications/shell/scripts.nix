{}: {
  flake.modules.homeManager.scripts = { pkgs, ... }: {
    home.packages = let
      ils = pkgs.writeShellApplication {
        name = "ils";

        text = ''
          for f in *; do if [ -f "$f" ]; then
            kitty +kitten icat "$f"
            echo "$f"
          fi done
        '';
      };
      screenshot = pkgs.writeShellApplication {
        name = "screenshot";

        runtimeInputs = with pkgs; [ grim slurp libnotify ];

        text = ''
          dir="$HOME/Pictures/screenshots"
          time=$(date +%Y-%m%d_%H-%M-%S)
          file="''${time}.png"

          shootarea() {
            grim -g "''$(slurp -c cba6f7)" - | tee "/tmp/screenshot.png" | wl-copy
            cp /tmp/screenshot.png "$dir/$file"
          }

          if [ ! -d "$dir" ]; then
            mkdir -p "$dir"
          fi

          shootarea
          notify-send -h string:x-canonical-private-synchronous:shot-notify -u low "Screenshot saved"
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

        runtimeInputs = with pkgs; [ lsd awww ];

        text = ''
          set_wallpaper() {
            awww img --transition-type top --transition-step 20 --transition-fps 60 "$1"
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

        runtimeInputs = with pkgs; [ awww ];

        text = ''
          set_wallpaper() {
            awww img --transition-type top --transition-step 20 --transition-fps 60 "$1"
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
    in [
      ils
      screenshot
      notify-pipe
      set_wallpaper
      random_wallpaper
      switch-gpg-yubikey
    ];
  };
}
