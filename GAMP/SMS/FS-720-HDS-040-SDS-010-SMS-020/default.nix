{
  layer = "SMS";
  traceId = "FS-720-HDS-040-SDS-010-SMS-020";
  parentSds = ../../SDS/FS-720-HDS-040-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-720-HDS-040-SDS-010-SMS-020-clab-client-origin-runtime-probes.md";
  titleSlug = "clab-client-origin-runtime-probes";
  sourceInputs."FS-720-HDS-040-SDS-010-SMS-020-construction" = {
    traceId = "FS-720-HDS-040-SDS-010-SMS-020";
    kind = "construction-check";
    sourcePath = "GAMP/SMT/FS-720-HDS-040-SDS-010-SMS-020/intent.nix";
    maxRuntimeTargets = 0;
  };
  source = {
    kind = "canonical-source-stub";
    sourcePath = "GAMP/SMS/FS-720-HDS-040-SDS-010-SMS-020/default.nix";
    evidenceBoundary = "construction-only";
  };
  status = "NOT OK";
}
