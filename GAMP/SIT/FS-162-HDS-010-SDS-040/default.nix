{
  layer = "SIT";
  traceId = "FS-162-HDS-010-SDS-040";
  smsInputs = {
    "FS-162-HDS-010-SDS-040-SMS-010" = {
      smtRow = ../../SMT/FS-162-HDS-010-SDS-040-SMS-010;
      sourcePath = "GAMP/SMT/FS-162-HDS-010-SDS-040-SMS-010/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-162-HDS-010-SDS-040-SMS-010-s-router-prod-comparable-projection.md";
      role = "construction-context-only";
      evidenceBoundary = "construction-only";
    };
  };
  evidence = {
    command = "bash tests/FS-162-HDS-010-SDS-040-SMS-010-s-router-prod-comparable-projection.sh";
    observedResult = "the construction-only FS-230 OpenConfig posture predicate passed at network-renderer-openconfig@9cff098bc2b9; no live OpenConfig device or production network is required or claimed";
  };
}
