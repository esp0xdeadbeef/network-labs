{
  layer = "SMS";
  traceId = "FS-540-HDS-010-SDS-010-SMS-042";
  parentSds = ../../SDS/FS-540-HDS-010-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-540-HDS-010-SDS-010-SMS-042-recursive-dns-projection-non-interference.md";
  titleSlug = "recursive-dns-projection-non-interference";
  purpose = "Canonical SMS mirror source-stub input template.";
  evidenceBoundary = "source-stub-only";
  sourceInputs = {
    "canonical-source-stub" = {
      traceId = "FS-540-HDS-010-SDS-010-SMS-042";
      kind = "source-reference";
      sourcePath = "GAMP/SMT/FS-540-HDS-010-SDS-010-SMS-042/intent.nix";
      maxRuntimeTargets = 0;
    };
  };
}
