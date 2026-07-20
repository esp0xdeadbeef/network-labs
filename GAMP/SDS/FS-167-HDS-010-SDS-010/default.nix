{
  layer = "SDS";
  traceId = "FS-167-HDS-010-SDS-010";
  purpose = "Canonical SMS mirror source-stub grouping.";
  smsInputs = {
    "FS-167-HDS-010-SDS-010-SMS-010" = {
      smsRow = ../../SMS/FS-167-HDS-010-SDS-010-SMS-010;
      miniSmtIds = [ "canonical-source-stub" ];
      inputKinds = [ "source-reference" ];
      evidenceBoundary = "source-stub-only";
    };
  };
}
