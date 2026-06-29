{
  layer = "SMT";
  traceId = "FS-800-HDS-030-SDS-020-SMS-010";
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-800-HDS-030-SDS-020-SMS-010-pppoe-customer-side-record-checks.md";
  titleSlug = "pppoe-customer-side-record-checks";
  source = {
    kind = "network-labs-hat-source-fixture";
    sourcePath = "GAMP/SMT/FS-800-HDS-030-SDS-020-SMS-010/intent.nix";
    inventories = {
      clab = "GAMP/SMT/FS-800-HDS-030-SDS-020-SMS-010/inventory-clab.nix";
      nixos = "GAMP/SMT/FS-800-HDS-030-SDS-020-SMS-010/inventory-nixos.nix";
      testClients = "GAMP/SMT/FS-800-HDS-030-SDS-020-SMS-010/inventory-test-clients.nix";
    };
    evidenceBoundary = "source-fixture-and-service-record-only";
  };
  status = "OK";
  evidence = {
    command = "bash tests/FS-800-HDS-030-SDS-020-SMS-010-pppoe-customer-side-source.sh";
    focusedTest = "tests/FS-800-HDS-030-SDS-020-SMS-010-pppoe-customer-side-source.sh";
    observedResult = "network-labs HAT/SAT provider-access source fixtures carry PPPoE customer records, ppp0 runtime interface expectations, default-route and peer-DNS client behavior, credential references, and no DHCP/SLAAC fallback; source fixture evidence only, not live HAT/SAT session proof";
  };
}
