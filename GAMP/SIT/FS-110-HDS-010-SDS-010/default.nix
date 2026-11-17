{
  layer = "SIT";
  traceId = "FS-110-HDS-010-SDS-010";
  smsInputs = {
    "FS-110-HDS-010-SDS-010-SMS-010" = {
      smtRow = ../../SMT/FS-110-HDS-010-SDS-010-SMS-010;
      sourcePath = "GAMP/SMT/FS-110-HDS-010-SDS-010-SMS-010/intent.nix";
      canonicalSms = "the platform GAMP/SMS/FS-110-HDS-010-SDS-010-SMS-010.md";
      role = "deterministic-evaluation";
      evidenceBoundary = "construction-only";
    };
  };
  evidence = {
    observedResult = "FS-110-HDS-010-SDS-010-SMS-010 is construction-only deterministic evaluation evidence from the platform specification; no router runtime targets are created.";
  };
}
