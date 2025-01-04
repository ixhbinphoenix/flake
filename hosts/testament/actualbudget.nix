{ config, pkgs, lib, inputs, ... }: {

  services.actual = {
    enable = true;
    openFirewall = false;
    settings = {
      port = 5006;
      hostname = "127.0.0.1";
    };
  };
}
