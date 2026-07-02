{
  meta = {
    traceId = "FS-540-HDS-010-SDS-010-SMS-020";
    scope = "dns-resolver-config";
  };
  hosts = { };
  endpoints = {
    access-dns = {
      ipv4 = [ "10.54.10.1" ];
      ipv6 = [ "fd42:540::1" ];
    };
  };
  deploymentHosts = {
    s-router-clab = {
      bridgeNetworks = {
        admin = { };
        branch = { };
        client = { };
      };
    };
  };
  containerlab = {
    capabilities.labEmulation = true;
    labEmulation = {
      scope = "harness";
      requests = [
        {
          providerEmulationMode = "fake-provider";
          handoffVlan = 11;
          liveUpstreamVlan = 4;
          dhcp4 = {
            address = "10.20.0.1/24";
            router = "10.20.0.1";
            clientAddress = "10.20.0.20";
            rangeStart = "10.20.0.20";
            rangeEnd = "10.20.0.99";
            leaseTime = "5m";
            sourcePrefix = "10.20.0.0/24";
          };
          nat44 = {
            enabled = true;
            sourcePrefix = "10.20.0.0/24";
          };
        }
      ];
    };
  };
}
