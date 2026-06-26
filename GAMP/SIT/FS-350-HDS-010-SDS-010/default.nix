{
  layer = "SIT";
  traceId = "FS-350-HDS-010-SDS-010";
  smsInputs = {
    "FS-350-HDS-010-SDS-010-SMS-010" = {
      smtRow = ../../SMT/FS-350-HDS-010-SDS-010-SMS-010;
      role = "prefix-subdivision-authority";
      evidenceBoundary = "construction-only";
    };
    "FS-350-HDS-010-SDS-010-SMS-020" = {
      smtRow = ../../SMT/FS-350-HDS-010-SDS-010-SMS-020;
      role = "reserved-prefix-denial";
      evidenceBoundary = "construction-only";
    };
    "FS-350-HDS-010-SDS-010-SMS-030" = {
      smtRow = ../../SMT/FS-350-HDS-010-SDS-010-SMS-030;
      role = "overlay-participant-ledger";
      evidenceBoundary = "construction-only";
    };
    "FS-350-HDS-010-SDS-010-SMS-040" = {
      smtRow = ../../SMT/FS-350-HDS-010-SDS-010-SMS-040;
      role = "authority-class-separation";
      evidenceBoundary = "construction-only";
    };
    "FS-350-HDS-010-SDS-010-SMS-050" = {
      smtRow = ../../SMT/FS-350-HDS-010-SDS-010-SMS-050;
      role = "cross-ledger-diagnostics";
      evidenceBoundary = "construction-only";
    };
  };
  evidence = {
    observedResult = "FS-350 chain: all five SMS traces construction-only; SMS-040 verified OK via NFM test; sibling traces pending individual verification";
  };
}
