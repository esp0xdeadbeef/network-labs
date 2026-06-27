{
  layer = "SMS";
  traceId = "FS-320-HDS-030-SDS-010-SMS-050";
  parentSds = ../../SDS/FS-320-HDS-030-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-320-HDS-030-SDS-010-SMS-050-per-interface-policy-table-connected-peer-routes.md";
  titleSlug = "per-interface-policy-table-connected-peer-routes";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-320-HDS-030-SDS-010-SMS-050";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-320-HDS-030-SDS-010-SMS-050/intent.nix";
      test = "tests/test-gamp-canonical-sms-mirror.sh";
      maxRuntimeTargets = 0;
    };
  };
  templateTests = [
    "tests/test-gamp-canonical-sms-mirror.sh"
  ];
}
