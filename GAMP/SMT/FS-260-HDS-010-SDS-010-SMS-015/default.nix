{
  layer = "SMT";
  traceId = "FS-260-HDS-010-SDS-010-SMS-015";
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-260-HDS-010-SDS-010-SMS-015-hat-policy-nft-rules-probe.md";
  titleSlug = "hat-policy-nft-rules-probe";
  source = {
    kind = "canonical-sms-source-stub";
    sourcePath = "GAMP/SMT/FS-260-HDS-010-SDS-010-SMS-015/intent.nix";
    inventories = {
      clab = "GAMP/SMT/FS-260-HDS-010-SDS-010-SMS-015/inventory-clab.nix";
      nixos = "GAMP/SMT/FS-260-HDS-010-SDS-010-SMS-015/inventory-nixos.nix";
      testClients = "GAMP/SMT/FS-260-HDS-010-SDS-010-SMS-015/inventory-test-clients.nix";
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
