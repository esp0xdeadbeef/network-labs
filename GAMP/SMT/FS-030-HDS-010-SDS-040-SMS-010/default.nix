{
  layer = "SMT";
  traceId = "FS-030-HDS-010-SDS-040-SMS-010";
  evidenceBoundary = "row-local-mini-smt";
  source = {
    kind = "intent-source";
    intent = ./intent.nix;
    expectedRelationIds = [
      "FS-030-HDS-010-SDS-040-SMS-010__mini-verify"
    ];
  };
  evidence = {
    owningRepo = "network-compiler";
    focusedTest = "tests/test-FS-030-HDS-010-SDS-040-SMS-010.sh";
    smtRow = "GAMP/SMT/README.md row for FS-030-HDS-010-SDS-040-SMS-010";
    status = "OK";
    command = "MINI_SMT_OFFLINE_VERIFY=0 bash tests/run-active-lab-mini-smt.sh FS-030-HDS-010-SDS-040-SMS-010";
    maxRuntimeTargets = 5;
    observedResult = "Compiler construction predicates are authoritative for platform independence; current live evidence must refresh NixOS and CLAB five-target runtime artifact and container enumeration before this row is considered live-closed.";
    scope = "Compiler platform independence contract: refuses renderer-specific, deployment-platform-specific, or vendor-specific concepts in compiler output; rejects intent fields selecting specific renderers or technologies";
  };
}
