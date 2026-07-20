{
  layer = "SMT";
  traceId = "FS-860-HDS-010-SDS-010-SMS-030";
  evidenceBoundary = "active-lab-mini-smt-runtime-artifact";
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-860-HDS-010-SDS-010-SMS-030-scoped-storage-binding-emission.md";
  titleSlug = "scoped-storage-binding-emission";
  source = {
    kind = "intent-source";
    sourcePath = "GAMP/SMT/FS-860-HDS-010-SDS-010-SMS-030/intent.nix";
    inventories = {
      clab = "GAMP/SMT/FS-860-HDS-010-SDS-010-SMS-030/inventory-clab.nix";
      nixos = "GAMP/SMT/FS-860-HDS-010-SDS-010-SMS-030/inventory-nixos.nix";
      testClients = "GAMP/SMT/FS-860-HDS-010-SDS-010-SMS-030/inventory-test-clients.nix";
    };
    expectedRelationIds = [ "FS-860-HDS-010-SDS-010-SMS-030__mini-verify" ];
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
