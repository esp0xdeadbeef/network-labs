{
  layer = "SMT";
  traceId = "FS-880-HDS-010-SDS-010-SMS-010";
  evidenceBoundary = "active-lab-mini-smt-runtime-artifact";
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-880-HDS-010-SDS-010-SMS-010-lease-namespace-ownership.md";
  titleSlug = "lease-namespace-ownership";
  source = {
    kind = "intent-source";
    sourcePath = "GAMP/SMT/FS-880-HDS-010-SDS-010-SMS-010/intent.nix";
    inventories = {
      clab = "GAMP/SMT/FS-880-HDS-010-SDS-010-SMS-010/inventory-clab.nix";
      nixos = "GAMP/SMT/FS-880-HDS-010-SDS-010-SMS-010/inventory-nixos.nix";
      testClients = "GAMP/SMT/FS-880-HDS-010-SDS-010-SMS-010/inventory-test-clients.nix";
    };
    expectedRelationIds = [ "FS-880-HDS-010-SDS-010-SMS-010__mini-verify" ];
    expectedRuntimeTargets = {
      "s-router-nixos" = 5;
      "s-router-clab" = 5;
      "s-router-test-clients" = 0;
    };
    evidenceBoundary = "active-lab-mini-smt-runtime-artifact";
  };
  status = "NOT OK";
  evidence = {
    observedResult = "NOT OK pending current live run: this row now requires active-lab runtime artifact proof on s-router-nixos, s-router-clab, and s-router-test-clients with runtime target counts 5/5/0.";
  };
}
