{
  nodeConfig,
  masterConfig,
  ...
}: let
  mkNetwork = clusterAddress: route: {
    matchConfig.Name = route.via;
    address = ["${clusterAddress}/24"];
    routes = [{Destination = route.range;}];
    linkConfig.MTUBytes = "9000";
    networkConfig.ConfigureWithoutCarrier = true;
  };
in {
  networking.hostName = nodeConfig.networking.hostName;
  systemd.network = {
    enable = true;
    networks =
      {
        "10-eth" = {
          matchConfig.Name = nodeConfig.networking.via;
          address = ["${nodeConfig.networking.ipv4Address}/${toString masterConfig.networking.ipRange}"];
          routes = [{Gateway = masterConfig.networking.gateway;}];
          dns = [masterConfig.networking.gateway];
          linkConfig.RequiredForOnline = "routable";
          networkConfig.DHCP = "ipv4";
        };
      }
      // (
        builtins.listToAttrs
        (map (route: {
            name = "20-${route.via}";
            value = mkNetwork nodeConfig.networking.clusterIpv4Address route;
          })
          nodeConfig.networking.routes)
      );
  };
}
