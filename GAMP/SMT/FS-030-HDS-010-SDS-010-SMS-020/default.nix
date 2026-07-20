{
  layer = "SMT";
  traceId = "FS-030-HDS-010-SDS-010-SMS-020";
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-030-HDS-010-SDS-010-SMS-020-realization-binder-authority.md";
  titleSlug = "realization-binder-authority";
  source = {
    kind = "intent-source";
    sourcePath = "GAMP/SMT/FS-030-HDS-010-SDS-010-SMS-020/intent.nix";
    inventories = {
      clab = "GAMP/SMT/FS-030-HDS-010-SDS-010-SMS-020/inventory-clab.nix";
      nixos = "GAMP/SMT/FS-030-HDS-010-SDS-010-SMS-020/inventory-nixos.nix";
      testClients = "GAMP/SMT/FS-030-HDS-010-SDS-010-SMS-020/inventory-test-clients.nix";
    };
    evidenceBoundary = "active-lab-mini-smt-runtime";
    expectedRelationIds = [
      "FS-030-HDS-010-SDS-010-SMS-020__mini-verify"
    ];
  };
  status = "OK";
  evidence = {
    owningRepo = "network-control-plane-model";
    maxRuntimeTargets = 5;
    scope = "CPM realization binder authority boundary: prevents inventory from creating unauthorized behavior and proves row-local mini-SMT artifacts";
    observedResult = "2026-07-04: realization-binder construction passed; offline verifier was disabled; pinned s-router-nixos build passed; live script passed on s-router-nixos, s-router-clab, and s-router-test-clients with runtime target counts 5/5/0 and evidence under /tmp/s-router-live-smoke/FS-030-HDS-010-SDS-010-SMS-020/20260704T035818Z.";
  };
}
