{
  layer = "SDS";
  traceId = "FS-310-HDS-020-SDS-010";
  purpose = "Canonical SMS mirror source-stub grouping.";
  smsInputs = {
    "FS-310-HDS-020-SDS-010-SMS-040" = {
      smsRow = ../../SMS/FS-310-HDS-020-SDS-010-SMS-040;
      miniSmtIds = [ "canonical-source-stub" ];
      inputKinds = [ "source-reference" ];
      evidenceBoundary = "source-stub-only";
    };
    "FS-310-HDS-020-SDS-010-SMS-050" = {
      smsRow = ../../SMS/FS-310-HDS-020-SDS-010-SMS-050;
      miniSmtIds = [ "canonical-source-stub" ];
      inputKinds = [ "source-reference" ];
      evidenceBoundary = "source-stub-only";
    };
    "FS-310-HDS-020-SDS-010-SMS-060" = {
      smsRow = ../../SMS/FS-310-HDS-020-SDS-010-SMS-060;
      miniSmtIds = [ "canonical-source-stub" ];
      inputKinds = [ "source-reference" ];
      evidenceBoundary = "source-stub-only";
    };
    "FS-310-HDS-020-SDS-010-SMS-070" = {
      smsRow = ../../SMS/FS-310-HDS-020-SDS-010-SMS-070;
      miniSmtIds = [ "canonical-source-stub" ];
      inputKinds = [ "source-reference" ];
      evidenceBoundary = "source-stub-only";
    };
    "FS-310-HDS-020-SDS-010-SMS-190" = {
      smsRow = ../../SMS/FS-310-HDS-020-SDS-010-SMS-190;
      miniSmtIds = [ "canonical-source-stub" ];
      inputKinds = [ "source-reference" ];
      evidenceBoundary = "source-stub-only";
    };
    "FS-310-HDS-020-SDS-010-SMS-200" = {
      smsRow = ../../SMS/FS-310-HDS-020-SDS-010-SMS-200;
      miniSmtIds = [ "canonical-source-stub" ];
      inputKinds = [ "source-reference" ];
      evidenceBoundary = "source-stub-only";
    };
    "FS-310-HDS-020-SDS-010-SMS-210" = {
      smsRow = ../../SMS/FS-310-HDS-020-SDS-010-SMS-210;
      miniSmtIds = [ "canonical-source-stub" ];
      inputKinds = [ "source-reference" ];
      evidenceBoundary = "source-stub-only";
    };
  };
  templateTests = [
    "tests/test-gamp-canonical-sms-mirror.sh"
  ];
}
