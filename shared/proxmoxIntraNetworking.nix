{
  publicInterfaceName,
  publicInterfaceAddress,
  publicNetworkSize,
  gatewayAddress,
  interInterfaceAddress,
  peers,
}: let
  buildPeerBlock = peer: ''
    auto ${peer.interInterfaceName}
    iface ${peer.interInterfaceName} inet static
            address ${interInterfaceAddress}
            netmask  255.255.255.0
            mtu 9000
            up ip route add ${peer.interInterfaceAddress}/32 dev ${peer.interInterfaceName}
            down ip route del ${peer.interInterfaceAddress}/32
  '';
  interfaces = ''
    auto lo
    iface lo inet loopback

    iface ${publicInterfaceName} inet manual

    auto vmbr0
    iface vmbr0 inet static
            address ${publicInterfaceAddress}/${publicNetworkSize}
            gateway ${gatewayAddress}
            bridge-ports {{ ${publicInterfaceName} }}
            bridge-stp off
            bridge-fd 0

    iface enp3s0 inet manual

    ${builtins.concatStringsSep "\n\n" (map (peer: buildPeerBlock) peers)}

    source /etc/network/interfaces.d/*
  '';
in {
  name = "Setup inter-cluster networking";
  "ansible.builtin.copy" = {
    src = "${interfaces}";
    dest = "/etc/network/interfaces";
    force = true;
    owner = "root";
    group = "root";
    mode = "0644";
  };
}
