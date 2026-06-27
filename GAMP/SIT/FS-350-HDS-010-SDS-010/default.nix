{
  layer = "SIT";
  traceId = "FS-350-HDS-010-SDS-010";
  smsInputs = {
    "FS-350-HDS-010-SDS-010-SMS-010" = {
      smtRow = ../../SMT/FS-350-HDS-010-SDS-010-SMS-010;
      sourcePath = "GAMP/SMT/FS-350-HDS-010-SDS-010-SMS-010/intent.nix";
      role = "prefix-subdivision-authority";
      evidenceBoundary = "construction-only";
    };
    "FS-350-HDS-010-SDS-010-SMS-020" = {
      smtRow = ../../SMT/FS-350-HDS-010-SDS-010-SMS-020;
      sourcePath = "GAMP/SMT/FS-350-HDS-010-SDS-010-SMS-020/intent.nix";
      role = "reserved-prefix-denial";
      evidenceBoundary = "construction-only";
    };
    "FS-350-HDS-010-SDS-010-SMS-030" = {
      smtRow = ../../SMT/FS-350-HDS-010-SDS-010-SMS-030;
      sourcePath = "GAMP/SMT/FS-350-HDS-010-SDS-010-SMS-030/intent.nix";
      role = "overlay-participant-ledger";
      evidenceBoundary = "construction-only";
    };
    "FS-350-HDS-010-SDS-010-SMS-040" = {
      smtRow = ../../SMT/FS-350-HDS-010-SDS-010-SMS-040;
      sourcePath = "GAMP/SMT/FS-350-HDS-010-SDS-010-SMS-040/intent.nix";
      role = "authority-class-separation";
      evidenceBoundary = "construction-only";
    };
    "FS-350-HDS-010-SDS-010-SMS-050" = {
      smtRow = ../../SMT/FS-350-HDS-010-SDS-010-SMS-050;
      sourcePath = "GAMP/SMT/FS-350-HDS-010-SDS-010-SMS-050/intent.nix";
      role = "cross-ledger-diagnostics";
      evidenceBoundary = "construction-only";
    };
  };
  evidence = {
    observedResult = "FS-350 chain: all five SMS traces construction-only, all verified OK (SMS-010/040 previously OK; SMS-020/030/050 flipped NOT_OK→OK 2026-06-27 — stale-status fix). Row-local SMS/SMT template directories created for SMS-020, SMS-030, SMS-050.";
  };
}
