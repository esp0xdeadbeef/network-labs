{
  layer = "SMT";
  traceId = "FS-800-HDS-030-SDS-010-SMS-010";
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-800-HDS-030-SDS-010-SMS-010-pppoe-provider-side.md";
  titleSlug = "pppoe-provider-side";
  source = {
    kind = "network-labs-hat-source-fixture";
    sourcePath = "GAMP/SMT/FS-800-HDS-030-SDS-010-SMS-010/intent.nix";
    inventories = {
      clab = "GAMP/SMT/FS-800-HDS-030-SDS-010-SMS-010/inventory-clab.nix";
      nixos = "GAMP/SMT/FS-800-HDS-030-SDS-010-SMS-010/inventory-nixos.nix";
      testClients = "GAMP/SMT/FS-800-HDS-030-SDS-010-SMS-010/inventory-test-clients.nix";
    };
    evidenceBoundary = "source-fixture-and-service-record-only";
  };
  status = "OK";
  evidence = {
    observedResult = "network-labs HAT/SAT provider-access source fixtures carry PPPoE provider records, isolated HAT bridges, provider-side service records, credential references, and no DHCP/SLAAC fallback; source fixture evidence only, not live HAT/SAT session proof";
  };
}
