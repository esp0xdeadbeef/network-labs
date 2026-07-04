{
  layer = "SMS";
  traceId = "FS-100-HDS-010-SDS-010-SMS-030";
  parentSds = ../../SDS/FS-100-HDS-010-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-100-HDS-010-SDS-010-SMS-030-signed-output-source-containment.md";
  titleSlug = "signed-output-source-containment";
  purpose = "Signed-output source containment construction-only source template.";
  evidenceBoundary = "construction-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-100-HDS-010-SDS-010-SMS-030";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-100-HDS-010-SDS-010-SMS-030/intent.nix";
      test = "tests/test-gamp-canonical-sms-mirror.sh";
      maxRuntimeTargets = 0;
    };
  };
  templateTests = [
    "tests/test-gamp-canonical-sms-mirror.sh"
  ];
}
