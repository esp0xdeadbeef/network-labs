{
  layer = "SMS";
  traceId = "FS-380-HDS-020-SDS-010-SMS-080";
  parentSds = ../../SDS/FS-380-HDS-020-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-380-HDS-020-SDS-010-SMS-080-nixos-nat-prefix-fabric-derivation.md";
  titleSlug = "nixos-nat-prefix-fabric-derivation";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-380-HDS-020-SDS-010-SMS-080";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-380-HDS-020-SDS-010-SMS-080/intent.nix";
      test = "tests/test-gamp-canonical-sms-mirror.sh";
      maxRuntimeTargets = 0;
    };
  };
  templateTests = [
    "tests/test-gamp-canonical-sms-mirror.sh"
  ];
}
