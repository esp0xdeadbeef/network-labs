{
  layer = "SDS";
  traceId = "FS-800-HDS-020-SDS-040";
  purpose = "Canonical SMS mirror source-stub grouping.";
  smsInputs = {
    "FS-800-HDS-020-SDS-040-SMS-010" = {
      smsRow = ../../SMS/FS-800-HDS-020-SDS-040-SMS-010;
      miniSmtIds = [ "canonical-source-stub" ];
      inputKinds = [ "source-reference" ];
      evidenceBoundary = "source-stub-only";
    };
  };
}
