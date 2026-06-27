{
  layer = "SMT";
  traceId = "FS-940-HDS-010-SDS-020-SMS-080";
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-940-HDS-010-SDS-020-SMS-080-route-cardinality-equivalence-diagnostics.md";
  titleSlug = "route-cardinality-equivalence-diagnostics";
  source = {
    kind = "canonical-sms-source-stub";
    sourcePath = "GAMP/SMT/FS-940-HDS-010-SDS-020-SMS-080/intent.nix";
    inventories = {
      clab = "GAMP/SMT/FS-940-HDS-010-SDS-020-SMS-080/inventory-clab.nix";
      nixos = "GAMP/SMT/FS-940-HDS-010-SDS-020-SMS-080/inventory-nixos.nix";
      testClients = "GAMP/SMT/FS-940-HDS-010-SDS-020-SMS-080/inventory-test-clients.nix";
    };
    evidenceBoundary = "source-stub-only";
  };
  status = "NOT OK";
  evidence = {
    command = null;
    focusedTest = null;
    observedResult = "canonical SMS mirrored from network-codex-agent; no focused mini-SMT or owning construction test is registered yet";
  };
}
