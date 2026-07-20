{
  layer = "SIT";
  traceId = "FS-400-HDS-010-SDS-010";
  smsInputs = {
    "FS-400-HDS-010-SDS-010-SMS-020" = {
      smtRow = ../../SMT/FS-400-HDS-010-SDS-010-SMS-020;
      sourcePath = "GAMP/SMT/FS-400-HDS-010-SDS-010-SMS-020/intent.nix";
      role = "ula-nat66-selection";
    };
    "FS-400-HDS-010-SDS-010-SMS-040" = {
      smtRow = ../../SMT/FS-400-HDS-010-SDS-010-SMS-040;
      sourcePath = "GAMP/SMT/FS-400-HDS-010-SDS-010-SMS-040/intent.nix";
      role = "overlay-client-gua-mode";
      evidenceBoundary = "construction-only";
    };
  };
  evidence = {
    sourcePaths = [
      "GAMP/SMT/FS-400-HDS-010-SDS-010-SMS-020/intent.nix"
      "GAMP/SMT/FS-400-HDS-010-SDS-010-SMS-040/intent.nix"
    ];
    observedResult = "2026-06-29: row-local structural/source-fixture checks passed for SMS-020 ULA NAT66 selection and SMS-040 overlay client GUA mode; construction/local-build evidence only.";
  };
}
