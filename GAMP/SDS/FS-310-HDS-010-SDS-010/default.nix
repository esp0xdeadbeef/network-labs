{
  layer = "SDS";
  traceId = "FS-310-HDS-010-SDS-010";
  purpose = "Canonical SMS mirror source-stub grouping.";
  smsInputs = {
    "FS-310-HDS-010-SDS-010-SMS-010" = {
      smsRow = ../../SMS/FS-310-HDS-010-SDS-010-SMS-010;
      miniSmtIds = [ "canonical-source-stub" ];
      inputKinds = [ "source-reference" ];
      evidenceBoundary = "source-stub-only";
    };
    "FS-310-HDS-010-SDS-010-SMS-020" = {
      smsRow = ../../SMS/FS-310-HDS-010-SDS-010-SMS-020;
      miniSmtIds = [ "canonical-source-stub" ];
      inputKinds = [ "source-reference" ];
      evidenceBoundary = "source-stub-only";
    };
    "FS-310-HDS-010-SDS-010-SMS-030" = {
      smsRow = ../../SMS/FS-310-HDS-010-SDS-010-SMS-030;
      miniSmtIds = [ "canonical-source-stub" ];
      inputKinds = [ "source-reference" ];
      evidenceBoundary = "source-stub-only";
    };
    "FS-310-HDS-010-SDS-010-SMS-120" = {
      smsRow = ../../SMS/FS-310-HDS-010-SDS-010-SMS-120;
      miniSmtIds = [ "canonical-source-stub" ];
      inputKinds = [ "source-reference" ];
      evidenceBoundary = "source-stub-only";
    };
    "FS-310-HDS-010-SDS-010-SMS-130" = {
      smsRow = ../../SMS/FS-310-HDS-010-SDS-010-SMS-130;
      miniSmtIds = [ "canonical-source-stub" ];
      inputKinds = [ "source-reference" ];
      evidenceBoundary = "source-stub-only";
    };
  };
  templateTests = [
    "tests/test-gamp-canonical-sms-mirror.sh"
  ];
}
