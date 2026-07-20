{
  layer = "SMS";
  traceId = "FS-720-HDS-010-SDS-040-SMS-010";
  parentSds = ../../SDS/FS-720-HDS-010-SDS-040;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-720-HDS-010-SDS-040-SMS-010-static-address-fixture.md";
  titleSlug = "static-address-fixture";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-720-HDS-010-SDS-040-SMS-010";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-720-HDS-010-SDS-040-SMS-010/intent.nix";
      maxRuntimeTargets = 0;
    };
  };
}
