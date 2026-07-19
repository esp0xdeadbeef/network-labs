{
  meta = {
    traceId = "FS-230-HDS-010-SDS-010-SMS-040";
    canonicalSms = "network-codex-agent/GAMP/SMS/FS-230-HDS-010-SDS-010-SMS-040-s-router-prod-nebula-ipv6-ingress-compatibility.md";
    renderer = "test-clients";
    scope = "isolated-construction-candidate";
    evidenceBoundary = "construction-only";
  };
  clients = {
    public-nebula-probe = {
      family = "ipv6";
      protocol = "udp";
      port = 4242;
      expectedReturn = "stateful";
    };
  };
  deploymentHosts = {
    s-router-test-clients = {
      hat.endpointClients = {
        public-nebula-probe = {
          network = "isolated-fs230-public";
          addressClass = "documentation-only";
        };
      };
    };
  };
}
