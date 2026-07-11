{
  layer = "SMS";
  traceId = "FS-030-HDS-010-SDS-020-SMS-010";
  parentSds = ../../SDS/FS-030-HDS-010-SDS-020;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-030-HDS-010-SDS-020-SMS-010-stage-topology-enforcement.md";
  titleSlug = "stage-topology-enforcement";
  purpose = "Active row-local mini-SMT input template for compiler stage-topology enforcement.";
  evidenceBoundary = "row-local-mini-smt";
  sourceInputs = {
    "FS-030-HDS-010-SDS-020-SMS-010" = {
      traceId = "FS-030-HDS-010-SDS-020-SMS-010";
      kind = "intent-source";
      sourcePath = "GAMP/SMT/FS-030-HDS-010-SDS-020-SMS-010/intent.nix";
      constructionTest = "network-compiler/tests/test-FS-030-HDS-010-SDS-020-SMS-010.sh";
      liveWrapper = "network-codex-agent/scripts/smt-live-FS-030-HDS-010-SDS-020-SMS-010.sh";
      test = "tests/run-active-lab-mini-smt.sh";
      maxRuntimeTargets = 5;
    };
  };
  templateTests = [
    "tests/run-active-lab-mini-smt.sh"
    "network-codex-agent/scripts/smt-live-FS-030-HDS-010-SDS-020-SMS-010.sh"
    "network-compiler/tests/test-FS-030-HDS-010-SDS-020-SMS-010.sh"
  ];
}
