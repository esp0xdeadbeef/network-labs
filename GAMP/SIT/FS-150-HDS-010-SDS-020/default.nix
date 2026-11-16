{
  layer = "SIT";
  traceId = "FS-150-HDS-010-SDS-020";
  smsInputs = {
    "FS-150-HDS-010-SDS-020-SMS-010" = {
      smtRow = ../../SMT/FS-150-HDS-010-SDS-020-SMS-010;
      sourcePath = "GAMP/SMT/FS-150-HDS-010-SDS-020-SMS-010/intent.nix";
      canonicalSms = "canonical-gamp/GAMP/SMS/FS-150-HDS-010-SDS-020-SMS-010.md";
      role = "portability-comparison-record";
      evidenceBoundary = "construction-only";
    };
  };
  evidence = {
    observedResult = "FS-150-HDS-010-SDS-020-SMS-010 is construction-only portability comparison evidence from canonical-gamp; no router runtime targets are created. Active-lab wrapper records live artifacts as context only.";
  };
}
