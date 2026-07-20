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
    command = null;
    observedResult = "the FS-230 OpenConfig posture predicate is construction-only; no integrated SIT runner or artifact evidence is specified or executed";
  };
}
