secrets: {
  nodes = {
    casper = {
      networking = {
        hostName = "Casper";
        ipv4Address = "192.168.178.80";
        clusterIpv4Address = "192.168.179.1";
        via = "enp2s0";
        routes = [
          {
            via = "enp1s0f0";
            range = "192.168.179.2/32";
          }
          {
            via = "enp1s0f1";
            range = "192.168.179.3/32";
          }
        ];
      };
      services = {
        nfs = {
          exports = [
            {
              path = "/mnt/fastData/nfs/exports/nas";
            }
            {
              path = "/mnt/slowData/nfs/exports/archive";
            }
          ];
        };
        webdav = {
          path = "/mnt/slowData/webdav/export";
        };
        borg = {
          path = "/mnt/slowData/borg/repos";
        };
      };
    };
    melchior = {
      networking = {
        hostName = "Melchior";
        ipv4Address = "192.168.178.81";
        clusterIpv4Address = "192.168.179.2";
        publicInterfaceName = "enp2s0";
        peers = [
          {
            interInterfaceName = "enp1s0f0";
            interInterfaceAddress = "192.168.179.1/32";
          }
          {
            interInterfaceName = "enp1s0f1";
            interInterfaceAddress = "192.168.179.3/32";
          }
        ];
      };
      services = {
        adguard = {
          port = 3000;
          settings = {
            users = [
              {
                name = secrets.services.adguard.userName;
                password = secrets.services.adguard.password;
              }
            ];
            theme = "dark";
            dns = {
              bind_hosts = ["0.0.0.0"];
              port = 53;
              anonymize_client_ip = true;
              upstream_dns = [
                "https://de-fra-dns-001.mullvad.net/dns-query"
                "https://dns.quad9.net/dns-query"
                "https://wikimedia-dns.org/dns-query"
              ];
              bootstrap_dns = [
                "185.71.138.138"
              ];
              private_networks = [
                "192.168.178.0/24"
              ];
              upstream_mode = "load_balance";
              use_http3_upstreams = true;
              cache_enabled = true;
              enable_dnssec = true;
            };
            filtering = {
              protection_enabled = true;
              filtering_enabled = true;
              safebrowsing_enabled = true;
            };
            filters = [
              {
                enabled = true;
                url = "https://media.githubusercontent.com/media/zachlagden/Pi-hole-Optimized-Blocklists/main/lists/all_domains.txt";
                name = "Zachlagden";
                id = "70458b14-327b-456a-bf01-d97ace2a9459";
              }
            ];
          };
        };
      };
    };
    balthasar = {};
    guf = {
      networking = {
        ipv4Address = "192.168.178.151";
      };
    };
  };
  deployment = {
    userName = "colmena";
    publicKey = secrets.deployment.deploymentUserPublicKey;
    privateKey = secrets.deployment.deploymentUserPrivateKey;
    port = 22;
  };
  networking = {
    ipRange = 24;
    gateway = "192.168.178.1";
  };
}
