{
  flake.modules.homeManager.syncthing = {
    services.syncthing = {
      enable = true;

      settings = {
        options = {
          urAccepted = -1;
        };
      };
    };
  };
}
