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
        }
      ];
    };
  };
  hosts = { };
  deploymentHosts = { };
}
