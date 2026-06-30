{
  layer = "SDS";
  traceId = "FS-380-HDS-020-SDS-010";
  purpose = "Internet mode verification mini POC input grouping.";
  smsInputs = {
    "FS-380-HDS-020-SDS-010-SMS-050" = {
      smsRow = ../../SMS/FS-380-HDS-020-SDS-010-SMS-050;
      miniSmtIds = [ "FS-380-HDS-020-SDS-010-SMS-050" ];
      inputKinds = [ "intent-source" ];
    };
  };
  templateTests = [
    "tests/test-gamp-sds-sms-template-mapping.sh"
    "tests/test-active-lab-mini-smt-sds-input-templates.sh"
    "tests/test-active-lab-mini-smt-sms-input-templates.sh"
  ];
}
