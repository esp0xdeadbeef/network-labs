{
  layer = "SIT";
  traceId = "FS-340-HDS-010-SDS-010";
  smsInputs = {
    "FS-340-HDS-010-SDS-010-SMS-040" = {
      smtRow = ../../SMT/FS-340-HDS-010-SDS-010-SMS-040;
      sourcePath = "GAMP/SMT/FS-340-HDS-010-SDS-010-SMS-040/intent.nix";
      role = "sms-040-module";
      evidenceBoundary = "construction-only";
    };
    "FS-340-HDS-010-SDS-010-SMS-010" = {
      smtRow = ../../SMT/FS-340-HDS-010-SDS-010-SMS-010;
      sourcePath = "GAMP/SMT/FS-340-HDS-010-SDS-010-SMS-010/intent.nix";
      role = "row-local-source-stub";
      evidenceBoundary = "source-stub-only";
    };
};
  evidence = {
    observedResult = "Construction-only trace chain. SMT row pending verification at network-codex-agent HEAD.";
  };
}
