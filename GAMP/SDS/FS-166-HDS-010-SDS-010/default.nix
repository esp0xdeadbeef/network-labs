{
  layer = "SDS";
  traceId = "FS-166-HDS-010-SDS-010";
  purpose = "Active-lab renderer-entry mini POC input grouping.";
  smsInputs = {
    "FS-166-HDS-010-SDS-010-SMS-901" = {
      smsRow = ../../SMS/FS-166-HDS-010-SDS-010-SMS-901;
      miniSmtIds = [ "FS-166-HDS-010-SDS-010-SMS-901" ];
      inputKinds = [ "renderer-input" ];
    };
    "FS-166-HDS-010-SDS-010-SMS-902" = {
      smsRow = ../../SMS/FS-166-HDS-010-SDS-010-SMS-902;
      miniSmtIds = [ "FS-166-HDS-010-SDS-010-SMS-902" ];
      inputKinds = [ "renderer-input" ];
    };
    "FS-166-HDS-010-SDS-010-SMS-903" = {
      smsRow = ../../SMS/FS-166-HDS-010-SDS-010-SMS-903;
      miniSmtIds = [ "FS-166-HDS-010-SDS-010-SMS-903" ];
      inputKinds = [ "renderer-input" ];
    };
    "FS-166-HDS-010-SDS-010-SMS-904" = {
      smsRow = ../../SMS/FS-166-HDS-010-SDS-010-SMS-904;
      miniSmtIds = [ "FS-166-HDS-010-SDS-010-SMS-904" ];
      inputKinds = [ "renderer-input" ];
    };
    "FS-166-HDS-010-SDS-010-SMS-905" = {
      smsRow = ../../SMS/FS-166-HDS-010-SDS-010-SMS-905;
      miniSmtIds = [ "FS-166-HDS-010-SDS-010-SMS-905" ];
      inputKinds = [ "renderer-input" ];
    };
    "FS-166-HDS-010-SDS-010-SMS-906" = {
      smsRow = ../../SMS/FS-166-HDS-010-SDS-010-SMS-906;
      miniSmtIds = [ "FS-166-HDS-010-SDS-010-SMS-906" ];
      inputKinds = [ "renderer-input" ];
    };
  };
  templateTests = [
    "tests/test-gamp-sds-sms-template-mapping.sh"
    "tests/test-active-lab-mini-smt-sds-input-templates.sh"
    "tests/test-active-lab-mini-smt-sms-input-templates.sh"
  ];
}
