{
  layer = "SMT";
  traceId = "FS-040-HDS-010-SDS-010-SMS-010";
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-040-HDS-010-SDS-010-SMS-010-public-inventory-boundary.md";
  titleSlug = "public-inventory-boundary";
  source = {
    kind = "intent-source";
    sourcePath = "GAMP/SMT/FS-040-HDS-010-SDS-010-SMS-010/intent.nix";
    inventories = {
      clab = "GAMP/SMT/FS-040-HDS-010-SDS-010-SMS-010/inventory-clab.nix";
      nixos = "GAMP/SMT/FS-040-HDS-010-SDS-010-SMS-010/inventory-nixos.nix";
      testClients = "GAMP/SMT/FS-040-HDS-010-SDS-010-SMS-010/inventory-test-clients.nix";
    };
    evidenceBoundary = "construction-plus-live-active-lab-artifact";
  };
  status = "NOT OK";
  evidence = {
    command = "network-codex-agent/scripts/smt-live-FS-040-HDS-010-SDS-010-SMS-010.sh";
    focusedTest = "network-control-plane-model/tests/FS-040-HDS-010-SDS-010-SMS-010-public-inventory-boundary.sh";
    observedResult = "focused construction proof exists and active-lab runner is registered; current live evidence is still required before marking OK";
  };
}
