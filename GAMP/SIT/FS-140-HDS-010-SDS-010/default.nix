{
  layer = "SIT";
  traceId = "FS-140-HDS-010-SDS-010";
  smsInputs = {
    "FS-140-HDS-010-SDS-010-SMS-010" = {
      smtRow = ../../SMT/FS-140-HDS-010-SDS-010-SMS-010;
      sourcePath = "GAMP/SMT/FS-140-HDS-010-SDS-010-SMS-010/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-140-HDS-010-SDS-010-SMS-010-scoped-output-boundary.md";
      role = "scoped-output-boundary";
      evidenceBoundary = "construction-only";
    };
  };
  evidence = {
    observedResult = "FS-140-HDS-010-SDS-010-SMS-010 is construction-only scoped output boundary evidence from network-control-plane-model; no router runtime targets are created. Active-lab wrapper records live artifacts as context only.";
  };
}
