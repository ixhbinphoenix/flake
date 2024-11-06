{ config, pkgs, lib, inputs, ... }: let
  basePath = "/var/lib/baikal";
  configPath = basePath + "/config";
  data = basePath + "/data";
in {

  systemd.tmpfiles.rules = let
    user = config.users.users.nginx.name;
    group = config.users.users.nginx.group;
  in [
    "d '${basePath}' 0777 ${user} ${group} - -"
    "z '${basePath}' 0777 ${user} ${group} - -"
    "d '${configPath}' 0777 ${user} ${group} - -"
    "z '${configPath}' 0777 ${user} ${group} - -"
    "d '${data}' 0777 ${user} ${group} - -"
    "z '${data}' 0777 ${user} ${group} - -"
  ];

  virtualisation.quadlet.containers.baikal = let
    nginxuser = config.users.users.nginx;
    uid = nginxuser.uid;
    gid = config.users.groups.${nginxuser.group}.gid;
  in {
    containerConfig = {
      image = "docker.io/ckulka/baikal:nginx";
      name = "baikal";
      autoUpdate = "registry";

      podmanArgs = [
        "-p 727:80"
      ];

      userns = "keep-id:uid=${builtins.toString uid},gid=${builtins.toString gid}";

      environments = {
        BAIKAL_SKIP_CHOWN=1;
      };

      volumes = [
        "${configPath}:/var/www/baikal/config"
        "${data}:/var/www/baikal/Specific"
      ];
    };
  };
}
