{
  layer = "SMS";
  traceId = "FS-060-HDS-010-SDS-010-SMS-010";
  parentSds = ../../SDS/FS-060-HDS-010-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-060-HDS-010-SDS-010-SMS-010-runtime-fact-boundary.md";
  titleSlug = "runtime-fact-boundary";
  purpose = "Runtime fact boundary template (active-lab runtime SMT OK).";
  evidenceBoundary = "runtime";
  sourceInputs = {
    "row-local" = {
      traceId = "FS-060-HDS-010-SDS-010-SMS-010";
      kind = "intent-source";
      sourcePath = "GAMP/SMT/FS-060-HDS-010-SDS-010-SMS-010/intent.nix";
      test = "tests/run-active-lab-mini-smt.sh";
      maxRuntimeTargets = 5;
    };
  };
  templateTests = [
    "tests/test-gamp-canonical-sms-mirror.sh"
  ];
}
