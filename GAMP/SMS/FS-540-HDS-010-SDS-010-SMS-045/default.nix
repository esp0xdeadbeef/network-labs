{
  layer = "SMS";
  traceId = "FS-540-HDS-010-SDS-010-SMS-045";
  parentSds = ../../SDS/FS-540-HDS-010-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-540-HDS-010-SDS-010-SMS-045-prod-like-access-recursive-dns.md";
  titleSlug = "prod-like-access-recursive-dns";
  purpose = "Canonical SMS mirror for prod-like recursive DNS over the access-vlan2 selector path and VLAN4 upstream.";
  evidenceBoundary = "source-stub-plus-live-clab-script";
  source = {
    intent = "GAMP/SMT/FS-540-HDS-010-SDS-010-SMS-045/intent.nix";
    inventoryNixos = "GAMP/SMT/FS-540-HDS-010-SDS-010-SMS-045/inventory-nixos.nix";
    inventoryClab = "GAMP/SMT/FS-540-HDS-010-SDS-010-SMS-045/inventory-clab.nix";
    testClients = "GAMP/SMT/FS-540-HDS-010-SDS-010-SMS-045/inventory-test-clients.nix";
  };
  sourceInputs = {
    "FS-540-HDS-010-SDS-010-SMS-045" = {
      traceId = "FS-540-HDS-010-SDS-010-SMS-045";
      kind = "intent-source";
      sourcePath = "GAMP/SMT/FS-540-HDS-010-SDS-010-SMS-045/intent.nix";
      maxRuntimeTargets = 5;
    };
  };
  evidence = {
    sourcePaths = [
      "GAMP/SMT/FS-540-HDS-010-SDS-010-SMS-045/intent.nix"
      "GAMP/SMT/FS-540-HDS-010-SDS-010-SMS-045/inventory-nixos.nix"
      "GAMP/SMT/FS-540-HDS-010-SDS-010-SMS-045/inventory-clab.nix"
      "GAMP/SMT/FS-540-HDS-010-SDS-010-SMS-045/inventory-test-clients.nix"
    ];
  };
}
