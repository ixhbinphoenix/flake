{ inputs, pkgs, ... }: { 
  imports = [
    ./hardware-configuration.nix
    ./networking.nix
  ];

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/vda";

  time.timeZone = "Europe/Berlin";

  sops.defaultSopsFile = ../../secrets/lucy.yaml;

  stages.server = {
    enable = true;

    metrics.enable = true;
    services = {
      nginx = {
        enable = true;
        domains = [ "garnix.dev" "ixhby.dev" "faggirl.gay" ];
        internalDomains = true;
      };
      slskd.enable = true;
      navidrome.enable = true;
      searxng.enable = true;
      ntfy.enable = true;
      forgejo.enable = true;
      zipline.enable = true;
      garnix.enable = true;
      unbound.enable = true;
      immich.enable = true;
      jellyfin.enable = true;
      copyparty.enable = true;
    };
  };

  nixpkgs.overlays = [ inputs.nix-minecraft.overlay ];
  nixpkgs.config.allowUnfree = true;

  services.minecraft-servers = {
    enable = true;
    eula = true;
    servers.bac2bac = let
      players = {
        ixhbinphoenix = "114e819b-26ab-4df9-91bf-57d5dfd9d13d";
        "confusedBREAD_" = "7d486fb4-d42f-4a2a-a1ac-90a87580f518";
        ketapuppy = "aedf7e91-0cd1-455b-9c51-667fd2ddbea4";
      };
    in {
      enable = true;
      openFirewall = true;
      autoStart = true;
      package = pkgs.fabricServers.fabric-1_21_10;

      # Flags generated with flags.sh (aikar's)
      jvmOpts = "-Xms8192M -Xmx8192M --add-modules=jdk.incubator.vector -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20";

      serverProperties = {
        server-port = 25565;
        difficulty = 3;
        gamemode = 0;
        max-players = 20;
        motd = "";
        white-list = true;
      };

      operators = players;
      whitelist = players;

      symlinks = {

        "mods" = pkgs.linkFarmFromDrvs "mods" (builtins.attrValues {
          fabric-api = pkgs.fetchurl { url = "https://cdn.modrinth.com/data/P7dR8mSH/versions/dQ3p80zK/fabric-api-0.138.3%2B1.21.10.jar"; sha512 = "dc73a3653c299476d1f70cb692c4e35ac3f694b3b0873e3d0b729e952e992b878d1a8e0b1d1049a442a0d483d3068073194f15af52ea9938544616e20433cc38"; };
          lithium = pkgs.fetchurl { url = "https://cdn.modrinth.com/data/gvQqBUqZ/versions/NsswKiwi/lithium-fabric-0.20.1%2Bmc1.21.10.jar"; sha512 = "79b2892d123f3bb12649927dd8fccc25c955ff38a19f3aba7cd0180c4cf5506c2a76d49418b13050f90bba7bb59f3623af06e8a275e2ae8c63808084043902bb"; };
          ferritecore = pkgs.fetchurl { url = "https://cdn.modrinth.com/data/uXXizFIs/versions/MGoveONm/ferritecore-8.0.2-fabric.jar"; sha512 = "8c3890fb116dfaf681f5f483ea0d1bfecfb87dd584cc72e772fe43ea6ecf15a09c782fedbe5cea3b8bf7e930bd5c00753a619ac5ce7afa7fd092769d68e9beec"; };
          nochatreports = pkgs.fetchurl { url = "https://cdn.modrinth.com/data/qQyHxfxd/versions/78RjC1gi/NoChatReports-FABRIC-1.21.10-v2.16.0.jar"; sha512 = "39b2f284f73f8290012b8b9cc70085d59668547fc7b4ec43ab34e4bca6b39a6691fbe32bc3326e40353ba9c16a06320e52818315be77799a5aad526370cbc773"; };
          krypton = pkgs.fetchurl { url = "https://cdn.modrinth.com/data/fQEb0iXm/versions/O9LmWYR7/krypton-0.2.10.jar"; sha512 = "4dcd7228d1890ddfc78c99ff284b45f9cf40aae77ef6359308e26d06fa0d938365255696af4cc12d524c46c4886cdcd19268c165a2bf0a2835202fe857da5cab"; };
          distanthorizons = pkgs.fetchurl { url = "https://cdn.modrinth.com/data/uCdwusMi/versions/9Y10ZuWP/DistantHorizons-2.3.6-b-1.21.10-fabric-neoforge.jar"; sha512 = "1b1b70b7ec6290d152a5f9fa3f2e68ea7895f407c561b56e91aba3fdadef277cd259879676198d6481dcc76a226ff1aa857c01ae9c41be3e963b59546074a1fc"; };
          spark = pkgs.fetchurl { url = "https://cdn.modrinth.com/data/l6YH9Als/versions/eqIoLvsF/spark-1.10.152-fabric.jar"; sha512 = "f99295f91e4bdb8756547f52e8f45b1649d08ad18bc7057bb68beef8137fea1633123d252cfd76a177be394a97fc1278fe85df729d827738d8c61f341604d679"; };
          servux = pkgs.fetchurl { url = "https://cdn.modrinth.com/data/zQhsx8KF/versions/4NqOw9an/servux-fabric-1.21.10-0.8.3.jar"; sha512 = "c9af5c2fcee3c7a4877d1cc75bddb5667fa22cf122320906102937ef0638a19acd73926863aa5477809c171b2654c969b358773fa31ab9770b48a50a649778e5"; };
        });
      };

      files = {
        "world/datapacks" = pkgs.linkFarmFromDrvs "datapacks" (builtins.attrValues {
          bacpack = pkgs.fetchurl {
            url = "https://cdn.modrinth.com/data/VoVJ47kN/versions/Zs1sLWzb/BlazeandCave%27s%20Advancements%20Pack%201.20.1.zip";
            sha512 = "226a61ceffbb7b32d906a2218be7e038b2b9ed5301442141e2afcc659c1a0e18feb19d87ef1acda88312b9b6b6d1e55c693b862a9565c7c51b4a6cc6f263fc1c";
          };
        });
      };
    };
  };

  system.stateVersion = "25.05";
}

