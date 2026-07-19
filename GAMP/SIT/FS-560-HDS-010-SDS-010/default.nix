{
  layer = "SIT";
  traceId = "FS-560-HDS-010-SDS-010";
  smsInputs = {
    "FS-560-HDS-010-SDS-010-SMS-040" = {
      smtRow = ../../SMT/FS-560-HDS-010-SDS-010-SMS-040;
      sourcePath = "GAMP/SMT/FS-560-HDS-010-SDS-010-SMS-040/intent.nix";
      role = "sms-040-module";
      evidenceBoundary = "construction-only";
    };
    "FS-560-HDS-010-SDS-010-SMS-050" = {
      smtRow = ../../SMT/FS-560-HDS-010-SDS-010-SMS-050;
      sourcePath = "GAMP/SMT/FS-560-HDS-010-SDS-010-SMS-050/intent.nix";
      role = "protected-reservation-name-publication";
      evidenceBoundary = "live-protected-name-publication";
    };
  };
  evidence = {
    observedResult = "SMS-040 remains construction-only; SMS-050 requires an isolated three-host cold stage on both NixOS and CLAB before its live boundary can close.";
  };
}
