{
  layer = "SMS";
  traceId = "FS-370-HDS-010-SDS-010-SMS-101";
  parentSds = ../../SDS/FS-370-HDS-010-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-370-HDS-010-SDS-010-SMS-101-policy-ds-per-lane-return-path-routing.md";
  titleSlug = "policy-ds-per-lane-return-path-routing";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-370-HDS-010-SDS-010-SMS-101";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-370-HDS-010-SDS-010-SMS-101/intent.nix";
      test = "tests/test-gamp-canonical-sms-mirror.sh";
      maxRuntimeTargets = 0;
    };
  };
  templateTests = [
    "tests/test-gamp-canonical-sms-mirror.sh"
  ];
}
