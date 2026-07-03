{
  layer = "SMS";
  traceId = "FS-020-HDS-010-SDS-010-SMS-010";
  parentSds = ../../SDS/FS-020-HDS-010-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-020-HDS-010-SDS-010-SMS-010-source-class-assignment.md";
  titleSlug = "source-class-assignment";
  purpose = "Row-local mini-SMT source for source-class assignment.";
  evidenceBoundary = "row-local-mini-smt";
  sourceInputs = {
    "FS-020-HDS-010-SDS-010-SMS-010" = {
      traceId = "FS-020-HDS-010-SDS-010-SMS-010";
      kind = "intent-source";
      sourcePath = "GAMP/SMT/FS-020-HDS-010-SDS-010-SMS-010/intent.nix";
      test = "../network-codex-agent/scripts/smt-live-FS-020-HDS-010-SDS-010-SMS-010.sh";
      maxRuntimeTargets = 5;
    };
  };
  templateTests = [
    "tests/test-gamp-canonical-sms-mirror.sh"
  ];
}
