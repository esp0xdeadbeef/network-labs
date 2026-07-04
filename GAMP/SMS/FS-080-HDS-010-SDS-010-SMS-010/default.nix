{
  layer = "SMS";
  traceId = "FS-080-HDS-010-SDS-010-SMS-010";
  parentSds = ../../SDS/FS-080-HDS-010-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-080-HDS-010-SDS-010-SMS-010-missing-ambiguous-fact-failure.md";
  titleSlug = "missing-ambiguous-fact-failure";
  purpose = "Missing-or-ambiguous fact failure template (active-lab runtime SMT OK).";
  evidenceBoundary = "runtime";
  sourceInputs = {
    "row-local" = {
      traceId = "FS-080-HDS-010-SDS-010-SMS-010";
      kind = "intent-source";
      sourcePath = "GAMP/SMT/FS-080-HDS-010-SDS-010-SMS-010/intent.nix";
      test = "tests/run-active-lab-mini-smt.sh";
      maxRuntimeTargets = 5;
    };
  };
  templateTests = [
    "tests/test-gamp-canonical-sms-mirror.sh"
  ];
}
