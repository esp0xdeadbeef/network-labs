{
  layer = "SDS";
  traceId = "FS-370-HDS-010-SDS-010";
  purpose = "Lane egress binding mini POC input grouping.";
  smsInputs = {
    "FS-370-HDS-010-SDS-010-SMS-040" = {
      smsRow = ../../SMS/FS-370-HDS-010-SDS-010-SMS-040;
      inputKinds = [ "source-reference" ];
      evidenceBoundary = "construction-only";
    };
    "FS-370-HDS-010-SDS-010-SMS-050" = {
      smsRow = ../../SMS/FS-370-HDS-010-SDS-010-SMS-050;
      miniSmtIds = [ "lane-egress-binding" ];
      inputKinds = [ "intent-source" ];
    };
  };
  templateTests = [
    "tests/test-gamp-sds-sms-template-mapping.sh"
    "tests/test-active-lab-mini-smt-sds-input-templates.sh"
    "tests/test-active-lab-mini-smt-sms-input-templates.sh"
  ];
}
