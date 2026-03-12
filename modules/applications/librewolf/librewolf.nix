{
  flake.modules.homeManger.librewolf = {
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
        };
      };
    };
  };
}
