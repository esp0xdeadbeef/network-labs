{
  layer = "SMS";
  traceId = "FS-320-HDS-040-SDS-010-SMS-060";
  parentSds = ../../SDS/FS-320-HDS-040-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-320-HDS-040-SDS-010-SMS-060-nixos-interface-role-classification.md";
  titleSlug = "nixos-interface-role-classification";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-320-HDS-040-SDS-010-SMS-060";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-320-HDS-040-SDS-010-SMS-060/intent.nix";
      test = "tests/test-gamp-canonical-sms-mirror.sh";
      maxRuntimeTargets = 0;
    };
  };
  templateTests = [
    "tests/test-gamp-canonical-sms-mirror.sh"
  ];
}
