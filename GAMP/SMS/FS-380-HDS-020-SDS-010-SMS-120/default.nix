{
  layer = "SMS";
  traceId = "FS-380-HDS-020-SDS-010-SMS-120";
  parentSds = ../../SDS/FS-380-HDS-020-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-380-HDS-020-SDS-010-SMS-120-prod-like-vlan4-client-egress.md";
  titleSlug = "prod-like-vlan4-client-egress";
  purpose = "Canonical SMS mirror for prod-like IPv4 client egress over VLAN4.";
  evidenceBoundary = "source-stub-plus-live-clab-script";
  source = {
    intent = "GAMP/SMT/FS-380-HDS-020-SDS-010-SMS-120/intent.nix";
    inventoryNixos = "GAMP/SMT/FS-380-HDS-020-SDS-010-SMS-120/inventory-nixos.nix";
    inventoryClab = "GAMP/SMT/FS-380-HDS-020-SDS-010-SMS-120/inventory-clab.nix";
    testClients = "GAMP/SMT/FS-380-HDS-020-SDS-010-SMS-120/inventory-test-clients.nix";
  };
  sourceInputs = {
    "FS-380-HDS-020-SDS-010-SMS-120" = {
      traceId = "FS-380-HDS-020-SDS-010-SMS-120";
      kind = "intent-source";
      sourcePath = "GAMP/SMT/FS-380-HDS-020-SDS-010-SMS-120/intent.nix";
      test = "tests/FS-380-HDS-020-SDS-010-SMS-120-prod-like-vlan4-client-egress.sh";
      maxRuntimeTargets = 5;
    };
  };
  templateTests = [
    "tests/FS-380-HDS-020-SDS-010-SMS-120-prod-like-vlan4-client-egress.sh"
    "tests/test-gamp-canonical-sms-mirror.sh"
  ];
  evidence = {
    sourcePaths = [
      "GAMP/SMT/FS-380-HDS-020-SDS-010-SMS-120/intent.nix"
      "GAMP/SMT/FS-380-HDS-020-SDS-010-SMS-120/inventory-nixos.nix"
      "GAMP/SMT/FS-380-HDS-020-SDS-010-SMS-120/inventory-clab.nix"
      "GAMP/SMT/FS-380-HDS-020-SDS-010-SMS-120/inventory-test-clients.nix"
    ];
  };
}
