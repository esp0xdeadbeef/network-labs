{
  layer = "SDS";
  traceId = "FS-800-HDS-010-SDS-013";
  purpose = "Canonical SMS mirror source-stub grouping.";
  smsInputs = {
    "FS-800-HDS-010-SDS-013-SMS-020" = {
      smsRow = ../../SMS/FS-800-HDS-010-SDS-013-SMS-020;
      miniSmtIds = [ "canonical-source-stub" ];
      inputKinds = [ "source-reference" ];
      evidenceBoundary = "source-stub-only";
    };
  };
}
