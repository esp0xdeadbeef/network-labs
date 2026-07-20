{
  layer = "SMT";
  traceId = "FS-470-HDS-010-SDS-010-SMS-080";
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-470-HDS-010-SDS-010-SMS-080-wireguard-policy-boundary.md";
  titleSlug = "wireguard-policy-boundary";
  source = {
    kind = "canonical-sms-source-stub";
    sourcePath = "GAMP/SMT/FS-470-HDS-010-SDS-010-SMS-080/intent.nix";
    inventories = {
      clab = "GAMP/SMT/FS-470-HDS-010-SDS-010-SMS-080/inventory-clab.nix";
      nixos = "GAMP/SMT/FS-470-HDS-010-SDS-010-SMS-080/inventory-nixos.nix";
      testClients = "GAMP/SMT/FS-470-HDS-010-SDS-010-SMS-080/inventory-test-clients.nix";
    };
    evidenceBoundary = "source-stub-only";
  };
  status = "NOT OK";
  evidence = {
    observedResult = "canonical SMS mirrored from network-codex-agent; no focused mini-SMT or owning construction test is registered yet";
  };
}
