{
  layer = "SMT";
  traceId = "FS-720-HDS-020-SDS-010-SMS-010";
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-720-HDS-020-SDS-010-SMS-010-endpoint-inventory-union.md";
  titleSlug = "endpoint-inventory-union";
  source = {
    kind = "canonical-sms-source-stub";
    sourcePath = "GAMP/SMT/FS-720-HDS-020-SDS-010-SMS-010/intent.nix";
    inventories = {
      clab = "GAMP/SMT/FS-720-HDS-020-SDS-010-SMS-010/inventory-clab.nix";
      nixos = "GAMP/SMT/FS-720-HDS-020-SDS-010-SMS-010/inventory-nixos.nix";
      testClients = "GAMP/SMT/FS-720-HDS-020-SDS-010-SMS-010/inventory-test-clients.nix";
    };
    evidenceBoundary = "source-stub-only";
  };
  status = "OK";
  evidence = {
    observedResult = "All 6 checks PASS at HEAD 4cc95123: Check 1 NixOS endpoints present, Check 2 CLAB endpoints present, Check 3 both substrates declare endpoints, SN1 CLAB-inventory-not-consumed, Recovery N1 both inventories carry endpoints, SN2 script-invented-endpoint detected. SMT construction evidence only.";
  };
}
