{ config, pkgs, lib, inputs, ... }: let
  path = "/var/lib/actualbudget";
in {

  users.users.actualbudget = {
    isSystemUser = true;
    useDefaultShell = true;
    group = "actualbudget";
    uid = 50001;
  };

  users.groups.actualbudget = {
    gid = 50001;
  };

  systemd.tmpfiles.rules = let
    user = config.users.users.actualbudget.name;
    group = config.users.users.actualbudget.group;
  in [
    "d '${path}' 0700 ${user} ${group} - -"
    "z '${path}' 0700 ${user} ${group} - -"
  ];

  virtualisation.quadlet.containers.actualbudget = let
    user = config.users.users.actualbudget;
    uid = user.uid;
    gid = config.users.groups.${user.group}.gid;
  in {
    containerConfig = {
      image = "docker.io/actualbudget/actual-server:latest";
      name = "actualbudget";
      autoUpdate = "registry";

      user = user.name;
      group = user.group;

      userns = "keep-id:uid=${builtins.toString uid},gid=${builtins.toString gid}";

      mounts = [
        "${path}:/data"
      ];
    };
  };
}
