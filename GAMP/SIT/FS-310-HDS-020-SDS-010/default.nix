{
  layer = "SIT";
  traceId = "FS-310-HDS-020-SDS-010";
  smsInputs = {
    "FS-310-HDS-020-SDS-010-SMS-040" = {
      smtRow = ../../SMT/FS-310-HDS-020-SDS-010-SMS-040;
      sourcePath = "GAMP/SMT/FS-310-HDS-020-SDS-010-SMS-040/intent.nix";
      role = "sms-040-module";
      evidenceBoundary = "construction-only";
    };
    "FS-310-HDS-020-SDS-010-SMS-200" = {
      smtRow = ../../SMT/FS-310-HDS-020-SDS-010-SMS-200;
      sourcePath = "GAMP/SMT/FS-310-HDS-020-SDS-010-SMS-200/intent.nix";
      role = "row-local-source-stub";
      evidenceBoundary = "source-stub-only";
    };
};
  evidence = {
    observedResult = "Construction-only trace chain. SMT row pending verification at network-codex-agent HEAD.";
  };
}
