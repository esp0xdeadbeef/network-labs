{
  layer = "SMT";
  traceId = "FS-030-HDS-010-SDS-010-SMS-030";
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-030-HDS-010-SDS-010-SMS-030-compiler-behavior-source-audit.md";
  titleSlug = "compiler-behavior-source-audit";
  source = {
    kind = "intent-source";
    sourcePath = "GAMP/SMT/FS-030-HDS-010-SDS-010-SMS-030/intent.nix";
    inventories = {
      clab = "GAMP/SMT/FS-030-HDS-010-SDS-010-SMS-030/inventory-clab.nix";
      nixos = "GAMP/SMT/FS-030-HDS-010-SDS-010-SMS-030/inventory-nixos.nix";
      testClients = "GAMP/SMT/FS-030-HDS-010-SDS-010-SMS-030/inventory-test-clients.nix";
    };
    evidenceBoundary = "active-lab-mini-smt-runtime";
    expectedRelationIds = [
      "FS-030-HDS-010-SDS-010-SMS-030__mini-verify"
    ];
  };
  status = "OK";
  evidence = {
    owningRepo = "network-compiler";
    smtRow = "GAMP/SMT/README.md row for FS-030-HDS-010-SDS-010-SMS-030";
    maxRuntimeTargets = 5;
    scope = "Compiler behavior source audit: ensures every behavior-creating compiler output field carries a user-intent source-class audit reference, fails closed on missing or non-intent sourceClass, and proves row-local mini-SMT artifacts";
    observedResult = "2026-07-04: compiler behavior source-audit construction passed; offline verifier was disabled; pinned s-router-nixos build passed; live script passed on s-router-nixos, s-router-clab, and s-router-test-clients with runtime target counts 5/5/0 and evidence under /tmp/s-router-live-smoke/FS-030-HDS-010-SDS-010-SMS-030/20260704T041126Z.";
  };
}
