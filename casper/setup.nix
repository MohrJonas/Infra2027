{
  nodeConfig,
  config,
  ...
}: let
  proxmoxIntraNetworking = import ../shared/proxmoxIntraNetworking;
in [
  {
    name = "Setup Casper";
    hosts = "all";
    tasks = [
      (proxmoxIntraNetworking {
        publicInterfaceName = nodeConfig.publicInterfaceName;
        publicInterfaceAddress = nodeConfig.ipv4Address;
        publicNetworkSize = config.networking.ipRange;
        gatewayAddress = config.networking.gateway;
        interInterfaceAddress = nodeConfig.clusterIpv4Address;
        peers = nodeConfig.peers;
      })
    ];
  }
]
