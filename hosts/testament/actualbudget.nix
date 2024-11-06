{ config, pkgs, lib, inputs, ... }: let
  path = "/var/lib/actualbudget";
in {

  systemd.tmpfiles.rules = [
    "d '${path}' 0700 root root - -"
    "z '${path}' 0700 root root - -"
  ];

  virtualisation.quadlet.containers.actualbudget = {
    containerConfig = {
      image = "docker.io/actualbudget/actual-server:latest";
      name = "actualbudget";
      autoUpdate = "registry";

      #user = user.name;
      #group = user.group;

      #userns = "keep-id:uid=${builtins.toString uid},gid=${builtins.toString gid}";

      volumes = [
        "${path}:/data"
      ];
    };
  };
}
