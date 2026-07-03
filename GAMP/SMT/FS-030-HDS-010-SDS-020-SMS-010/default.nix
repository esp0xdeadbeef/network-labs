{
  layer = "SMT";
  traceId = "FS-030-HDS-010-SDS-020-SMS-010";
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-030-HDS-010-SDS-020-SMS-010-stage-topology-enforcement.md";
  titleSlug = "stage-topology-enforcement";
  source = {
    kind = "intent-source";
    intent = ./intent.nix;
    expectedRelationIds = [
      "FS-030-HDS-010-SDS-020-SMS-010__mini-verify"
    ];
  };
  status = "OK";
  evidence = {
    command = "tests/run-active-lab-mini-smt.sh --source FS-030-HDS-010-SDS-020-SMS-010";
    focusedTest = "network-compiler/tests/test-FS-030-HDS-010-SDS-020-SMS-010.sh";
    maxRuntimeTargets = 5;
    observedResult = "compiler stage-topology construction test passes and row-local mini-SMT artifacts are expected on nixos/clab with zero test-client runtime targets";
  };
}
