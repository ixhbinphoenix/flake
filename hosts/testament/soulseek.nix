{ config, ...}: {

  sops.secrets.slskd = {
    sopsFile = ../../secrets/testament/slskd.env;
    format = "dotenv";
  };

  services.slskd = {
    enable = true;
    openFirewall = true;
    domain = null;
    environmentFile = config.sops.secrets.slskd.path;
    settings = {
      shares = {
        directories = [
          "/var/lib/navidrome-music"
          "!/var/lib/navidrome-music/spezi-ell"
          "!/var/lib/navidrome-music/soundboard"
        ];
        filters = [
          "rsync.sh$"
          "TheMissile\.wav(.asd)?$"
          "BCSRingtone.mp3"
        ];
      };
    };
  };
}
