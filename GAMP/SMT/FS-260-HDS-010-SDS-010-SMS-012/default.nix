{
  layer = "SMT";
  traceId = "FS-260-HDS-010-SDS-010-SMS-012";
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-260-HDS-010-SDS-010-SMS-012-emulation-subnet-fabric-chain-injection.md";
  titleSlug = "emulation-subnet-fabric-chain-injection";
  source = {
    kind = "canonical-sms-source-stub";
    sourcePath = "GAMP/SMT/FS-260-HDS-010-SDS-010-SMS-012/intent.nix";
    inventories = {
      clab = "GAMP/SMT/FS-260-HDS-010-SDS-010-SMS-012/inventory-clab.nix";
      nixos = "GAMP/SMT/FS-260-HDS-010-SDS-010-SMS-012/inventory-nixos.nix";
      testClients = "GAMP/SMT/FS-260-HDS-010-SDS-010-SMS-012/inventory-test-clients.nix";
    };
    evidenceBoundary = "source-stub-only";
  };
  status = "NOT OK";
  evidence = {
    observedResult = "canonical SMS mirrored from network-codex-agent; no focused mini-SMT or owning construction test is registered yet";
  };
}
