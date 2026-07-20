{
  layer = "SMT";
  traceId = "FS-380-HDS-020-SDS-010-SMS-080";
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-380-HDS-020-SDS-010-SMS-080-nixos-nat-prefix-fabric-derivation.md";
  titleSlug = "nixos-nat-prefix-fabric-derivation";
  source = {
    kind = "canonical-sms-source-stub";
    sourcePath = "GAMP/SMT/FS-380-HDS-020-SDS-010-SMS-080/intent.nix";
    inventories = {
      clab = "GAMP/SMT/FS-380-HDS-020-SDS-010-SMS-080/inventory-clab.nix";
      nixos = "GAMP/SMT/FS-380-HDS-020-SDS-010-SMS-080/inventory-nixos.nix";
      testClients = "GAMP/SMT/FS-380-HDS-020-SDS-010-SMS-080/inventory-test-clients.nix";
    };
    evidenceBoundary = "source-stub-only";
  };
  status = "NOT OK";
  evidence = {
    observedResult = "canonical SMS mirrored from network-codex-agent; no focused mini-SMT or owning construction test is registered yet";
  };
}
