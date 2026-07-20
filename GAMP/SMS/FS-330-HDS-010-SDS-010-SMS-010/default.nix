{
  layer = "SMS";
  traceId = "FS-330-HDS-010-SDS-010-SMS-010";
  parentSds = ../../SDS/FS-330-HDS-010-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-330-HDS-010-SDS-010-SMS-010-stable-client-address-identity.md";
  titleSlug = "stable-client-address-identity";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-330-HDS-010-SDS-010-SMS-010";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-330-HDS-010-SDS-010-SMS-010/intent.nix";
      maxRuntimeTargets = 0;
    };
  };
}
