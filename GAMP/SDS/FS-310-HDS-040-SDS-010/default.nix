{
  layer = "SDS";
  traceId = "FS-310-HDS-040-SDS-010";
  purpose = "Canonical SMS mirror source-stub grouping.";
  smsInputs = {
    "FS-310-HDS-040-SDS-010-SMS-100" = {
      smsRow = ../../SMS/FS-310-HDS-040-SDS-010-SMS-100;
      miniSmtIds = [ "canonical-source-stub" ];
      inputKinds = [ "source-reference" ];
      evidenceBoundary = "source-stub-only";
    };
    "FS-310-HDS-040-SDS-010-SMS-101" = {
      smsRow = ../../SMS/FS-310-HDS-040-SDS-010-SMS-101;
      miniSmtIds = [ "canonical-source-stub" ];
      inputKinds = [ "source-reference" ];
      evidenceBoundary = "source-stub-only";
    };
    "FS-310-HDS-040-SDS-010-SMS-102" = {
      smsRow = ../../SMS/FS-310-HDS-040-SDS-010-SMS-102;
      miniSmtIds = [ "canonical-source-stub" ];
      inputKinds = [ "source-reference" ];
      evidenceBoundary = "source-stub-only";
    };
    "FS-310-HDS-040-SDS-010-SMS-140" = {
      smsRow = ../../SMS/FS-310-HDS-040-SDS-010-SMS-140;
      miniSmtIds = [ "canonical-source-stub" ];
      inputKinds = [ "source-reference" ];
      evidenceBoundary = "source-stub-only";
    };
    "FS-310-HDS-040-SDS-010-SMS-150" = {
      smsRow = ../../SMS/FS-310-HDS-040-SDS-010-SMS-150;
      miniSmtIds = [ "canonical-source-stub" ];
      inputKinds = [ "source-reference" ];
      evidenceBoundary = "source-stub-only";
    };
    "FS-310-HDS-040-SDS-010-SMS-160" = {
      smsRow = ../../SMS/FS-310-HDS-040-SDS-010-SMS-160;
      miniSmtIds = [ "canonical-source-stub" ];
      inputKinds = [ "source-reference" ];
      evidenceBoundary = "source-stub-only";
    };
    "FS-310-HDS-040-SDS-010-SMS-170" = {
      smsRow = ../../SMS/FS-310-HDS-040-SDS-010-SMS-170;
      miniSmtIds = [ "canonical-source-stub" ];
      inputKinds = [ "source-reference" ];
      evidenceBoundary = "source-stub-only";
    };
    "FS-310-HDS-040-SDS-010-SMS-180" = {
      smsRow = ../../SMS/FS-310-HDS-040-SDS-010-SMS-180;
      miniSmtIds = [ "canonical-source-stub" ];
      inputKinds = [ "source-reference" ];
      evidenceBoundary = "source-stub-only";
    };
  };
  templateTests = [
    "tests/test-gamp-canonical-sms-mirror.sh"
  ];
}
