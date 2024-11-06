{ config, pkgs, lib, inputs, conduwuit, ... }: {

  users.users.conduit = {
    isSystemUser = true;
    useDefaultShell = true;
    group = "conduit";
  };

  users.groups.conduit = {};

  services.matrix-conduit = {
    package = conduwuit.packages."x86_64-linux".default;
    enable = true;

    settings.global = {
      # Until nixpkgs#353651 gets merged
      database_backend = "rocksdb";

      server_name = "ixhby.dev";
      trusted_servers = [
        "matrix.org"
      ];

      port = 6167;
      address = "127.0.0.1";
      max_request_size = 20000000;

      ip_range_denylist = [
        "127.0.0.0/8"
        "10.0.0.0/8"
        "172.16.0.0/12"
        "192.168.0.0/16"
        "100.64.0.0/10"
        "192.0.0.0/24"
        "169.254.0.0/16"
        "192.88.99.0/24"
        "198.18.0.0/15"
        "192.0.2.0/24"
        "198.51.100.0/24"
        "203.0.113.0/24"
        "224.0.0.0/4"
        "::1/128"
        "fe80::/10"
        "fc00::/7"
        "2001:db8::/32"
        "ff00::/8"
        "fec0::/10"
      ];

      allow_guest_registration = false;
      log_guest_registration = false;
      allow_guests_auto_join_rooms = false;

      allow_registration = true;

      allow_federation = true;

      allow_public_room_directory_over_federation = false;
      allow_public_room_directory_without_auth = false;
      lockdown_public_room_directory = false;
      allow_device_name_federation = false;
      allow_profile_lookup_federation_requests = true;

      allow_encryption = true;
      allow_check_for_updates = true;
      new_user_displayname_suffix = "";

      allow_local_presence = false;
      allow_incoming_presence = true;
      allow_outgoing_presence = false;
    };
  };

  sops.secrets.conduwuit = {
    owner = config.users.users.conduit.name;
    group = config.users.users.conduit.group;
    sopsFile = ../../secrets/testament/conduwuit.env;
    format = "dotenv";
  };

  systemd.services.conduit.serviceConfig = {
    EnvironmentFile = config.sops.secrets.conduwuit.path;
    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];
  };

  virtualisation.quadlet.containers.cinny.containerConfig = let 
    configFile = pkgs.writeTextFile {
      name = "cinny.json";
      text = builtins.toJSON {
        defaultHomeserver = 0;
        homeserverList = [
          "ixhby.dev"
        ];
        allowCustomHomeservers = true;

        featuresCommunities = {
          openAsDefault = false;
          spaces = [
            "#cinny-space:matrix.org"
          ];
          rooms = [
            "#cinny:matrix.org"
          ];
          servers = [ "envs.net" "matrix.org" ];
        };

        hashRouter = {
          enabled = false;
          basename = "/";
        };
      };
    };
  in {
    image = "ghcr.io/cinnyapp/cinny:latest";
    name = "cinny";
    autoUpdate = "registry";

    podmanArgs = [
      "-p 6168:80"
    ];

    volumes = [
      "${configFile}:/app/config.json"
    ];
  };
}
