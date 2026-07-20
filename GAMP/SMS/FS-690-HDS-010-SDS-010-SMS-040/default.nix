{
  layer = "SMS";
  traceId = "FS-690-HDS-010-SDS-010-SMS-040";
  parentSds = ../../SDS/FS-690-HDS-010-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-690-HDS-010-SDS-010-SMS-040-bounded-nix-evaluation-projection.md";
  titleSlug = "bounded-nix-evaluation-projection";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-690-HDS-010-SDS-010-SMS-040";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-690-HDS-010-SDS-010-SMS-040/intent.nix";
      maxRuntimeTargets = 0;
    };
  };
}
