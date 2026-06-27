{
  layer = "SIT";
  traceId = "FS-940-HDS-010-SDS-010";
  smsInputs = {
    "FS-940-HDS-010-SDS-010-SMS-040" = {
      smtRow = ../../SMT/FS-940-HDS-010-SDS-010-SMS-040;
      sourcePath = "GAMP/SMT/FS-940-HDS-010-SDS-010-SMS-040/intent.nix";
      role = "sms-040-module";
      evidenceBoundary = "construction-only";
    };
  };
  evidence = {
    observedResult = "Construction-only trace chain. SMT row pending verification at network-codex-agent HEAD.";
  };
}
