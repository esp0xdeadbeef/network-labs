{
  layer = "SDS";
  traceId = "FS-720-HDS-030-SDS-010";
  purpose = "Canonical SMS mirror source-stub grouping.";
  smsInputs = {
    "FS-720-HDS-030-SDS-010-SMS-021" = {
      smsRow = ../../SMS/FS-720-HDS-030-SDS-010-SMS-021;
      miniSmtIds = [ "canonical-source-stub" ];
      inputKinds = [ "source-reference" ];
      evidenceBoundary = "source-stub-only";
    };
    "FS-720-HDS-030-SDS-010-SMS-041" = {
      smsRow = ../../SMS/FS-720-HDS-030-SDS-010-SMS-041;
      miniSmtIds = [ "canonical-source-stub" ];
      inputKinds = [ "source-reference" ];
      evidenceBoundary = "source-stub-only";
    };
  };
}
