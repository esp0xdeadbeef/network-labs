{
  layer = "SMS";
  traceId = "FS-370-HDS-010-SDS-010-SMS-120";
  parentSds = ../../SDS/FS-370-HDS-010-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-370-HDS-010-SDS-010-SMS-120-nixos-per-lane-return-path-routing.md";
  titleSlug = "nixos-per-lane-return-path-routing";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-370-HDS-010-SDS-010-SMS-120";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-370-HDS-010-SDS-010-SMS-120/intent.nix";
      maxRuntimeTargets = 0;
    };
  };
}
