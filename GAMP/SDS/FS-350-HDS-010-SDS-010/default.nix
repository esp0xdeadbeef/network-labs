{
  layer = "SDS";
  traceId = "FS-350-HDS-010-SDS-010";
  purpose = "Prefix subdivision, reservation, and authority classification mini POC input grouping.";
  smsInputs = {
    "FS-350-HDS-010-SDS-010-SMS-010" = {
      smsRow = ../../SMS/FS-350-HDS-010-SDS-010-SMS-010;
      inputKinds = [ "source-reference" ];
      evidenceBoundary = "construction-only";
    };
    "FS-350-HDS-010-SDS-010-SMS-020" = {
      smsRow = ../../SMS/FS-350-HDS-010-SDS-010-SMS-020;
      inputKinds = [ "source-reference" ];
      evidenceBoundary = "construction-only";
    };
    "FS-350-HDS-010-SDS-010-SMS-030" = {
      smsRow = ../../SMS/FS-350-HDS-010-SDS-010-SMS-030;
      inputKinds = [ "source-reference" ];
      evidenceBoundary = "construction-only";
    };
    "FS-350-HDS-010-SDS-010-SMS-040" = {
      smsRow = ../../SMS/FS-350-HDS-010-SDS-010-SMS-040;
      inputKinds = [ "source-reference" ];
      evidenceBoundary = "construction-only";
    };
    "FS-350-HDS-010-SDS-010-SMS-050" = {
      smsRow = ../../SMS/FS-350-HDS-010-SDS-010-SMS-050;
      inputKinds = [ "source-reference" ];
      evidenceBoundary = "construction-only";
    };
  };
  templateTests = [
    "tests/test-gamp-sds-sms-template-mapping.sh"
  ];
}
