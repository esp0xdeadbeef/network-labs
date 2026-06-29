{
  meta = {
    traceId = "FS-540-HDS-010-SDS-010-SMS-020";
    canonicalSms = "network-codex-agent/GAMP/SMS/FS-540-HDS-010-SDS-010-SMS-020-cpm-dns-resolver-configuration-authority.md";
    renderer = "clab";
    scope = "row-local-clab-realization-source";
    evidenceBoundary = "source-plus-provider-emulation-prerequisite";
  };
  containerlab = {
    capabilities = {
      labEmulation = true;
    };
    labEmulation = {
      scope = "harness";
      requests = [
        {
          providerEmulationMode = "fake-provider";
          name = "fs540-dns-resolver-testnet";
          handoffVlan = 11;
          liveUpstreamVlan = 4;
          dhcp4 = {
            address = "10.20.0.1/24";
            router = "10.20.0.1";
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
  endpoints = {
    access-dns = {
      ipv4 = [ "10.54.10.1" ];
      ipv6 = [ "fd42:540::1" ];
    };
  };
  hosts = { };
  deploymentHosts = { };
}
