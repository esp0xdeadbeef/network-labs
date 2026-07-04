{
  layer = "SDS";
  traceId = "FS-100-HDS-010-SDS-010";
  purpose = "Emitter provenance and source identity mini POC input grouping.";
  smsInputs = {
    "FS-100-HDS-010-SDS-010-SMS-010" = {
      smsRow = ../../SMS/FS-100-HDS-010-SDS-010-SMS-010;
      miniSmtIds = [ "row-local" ];
      inputKinds = [ "source-reference" ];
      evidenceBoundary = "construction-only";
    };
    "FS-100-HDS-010-SDS-010-SMS-020" = {
      smsRow = ../../SMS/FS-100-HDS-010-SDS-010-SMS-020;
      miniSmtIds = [ "row-local" ];
      inputKinds = [ "source-reference" ];
      evidenceBoundary = "construction-only";
    };
    "FS-100-HDS-010-SDS-010-SMS-030" = {
      smsRow = ../../SMS/FS-100-HDS-010-SDS-010-SMS-030;
      miniSmtIds = [ "row-local" ];
      inputKinds = [ "source-reference" ];
    };
    "FS-100-HDS-010-SDS-010-SMS-040" = {
      smsRow = ../../SMS/FS-100-HDS-010-SDS-010-SMS-040;
      miniSmtIds = [ "row-local" ];
      inputKinds = [ "source-reference" ];
    };
    "FS-100-HDS-010-SDS-010-SMS-050" = {
      smsRow = ../../SMS/FS-100-HDS-010-SDS-010-SMS-050;
      miniSmtIds = [ "row-local" ];
      inputKinds = [ "source-reference" ];
    };
  };
  templateTests = [
    "tests/test-gamp-sds-sms-template-mapping.sh"
  ];
}
