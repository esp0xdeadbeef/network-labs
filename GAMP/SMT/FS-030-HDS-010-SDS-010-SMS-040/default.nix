{
  layer = "SMT";
  traceId = "FS-030-HDS-010-SDS-010-SMS-040";
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-030-HDS-010-SDS-010-SMS-040-cpm-binder-source-audit.md";
  titleSlug = "cpm-binder-source-audit";
  source = {
    kind = "intent-source";
    sourcePath = "GAMP/SMT/FS-030-HDS-010-SDS-010-SMS-040/intent.nix";
    inventories = {
      clab = "GAMP/SMT/FS-030-HDS-010-SDS-010-SMS-040/inventory-clab.nix";
      nixos = "GAMP/SMT/FS-030-HDS-010-SDS-010-SMS-040/inventory-nixos.nix";
      testClients = "GAMP/SMT/FS-030-HDS-010-SDS-010-SMS-040/inventory-test-clients.nix";
    };
    evidenceBoundary = "active-lab-mini-smt-runtime";
    expectedRelationIds = [
      "FS-030-HDS-010-SDS-010-SMS-040__mini-verify"
    ];
  };
  status = "OK";
  evidence = {
    owningRepo = "network-control-plane-model";
    command = "MINI_SMT_OFFLINE_VERIFY=0 bash tests/run-active-lab-mini-smt.sh FS-030-HDS-010-SDS-010-SMS-040";
    focusedTest = "../network-codex-agent/tests/test-smt-live-FS-030-HDS-010-SDS-010-SMS-040.sh";
    liveScript = "../network-codex-agent/scripts/smt-live-FS-030-HDS-010-SDS-010-SMS-040.sh";
    constructionTest = "../network-control-plane-model/tests/FS-030-HDS-010-SDS-010-SMS-020-cpm-realization-binder-source-audit.sh";
    smtRow = "GAMP/SMT/README.md row for FS-030-HDS-010-SDS-010-SMS-040";
    maxRuntimeTargets = 5;
    scope = "CPM binder source audit: ensures every CPM realization-binding field carries a binder source-class audit reference plus upstream behavior reference, fails closed on missing or cross-stage audit records";
    observedResult = "2026-07-04: CPM binder source-audit construction passed; offline verifier was disabled; pinned s-router-nixos build passed; live script passed on s-router-nixos, s-router-clab, and s-router-test-clients with runtime target counts 5/5/0 and evidence under /tmp/s-router-live-smoke/FS-030-HDS-010-SDS-010-SMS-040/20260704T042319Z.";
  };
}
