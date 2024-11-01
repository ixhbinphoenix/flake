{ config, pkgs, lib, inputs, ... }: let
  basePath = "/var/lib/baikal";
  configPath = basePath + "/config";
  data = basePath + "/data";
in {

  systemd.tmpfiles.rules = let
    user = config.users.users.nginx.name;
    group = config.users.users.nginx.group;
  in [
    "d '${basePath}' 0700 ${user} ${group} - -"
    "z '${basePath}' 0700 ${user} ${group} - -"
    "d '${configPath}' 0700 ${user} ${group} - -"
    "z '${configPath}' 0700 ${user} ${group} - -"
    "d '${data}' 0700 ${user} ${group} - -"
    "z '${data}' 0700 ${user} ${group} - -"
  ];

  virtualisation.quadlet.containers.baikal = let
    user = config.users.users.nginx;
    uid = user.uid;
    gid = config.users.groups.${user.group}.gid;
  in {
    containerConfig = {
      image = "docker.io/chulka/baikal:nginx";
      name = "baikal";
      autoUpdate = "registry";

      podmanArgs = [
        "-p 727:80"
      ];

      userns = "keep-id:uid=${builtins.toString uid},gid=${builtins.toString gid}";

      mounts = [
        "${configPath}:/var/www/baikal/config"
        "${data}:/var/www/baikal/Specific"
      ];
    };
  };
}
