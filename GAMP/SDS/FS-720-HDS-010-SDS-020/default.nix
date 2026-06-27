{
  layer = "SDS";
  traceId = "FS-720-HDS-010-SDS-020";
  purpose = "Endpoint harness consumption mini POC input grouping.";
  smsInputs = {
    "FS-720-HDS-010-SDS-020-SMS-020" = {
      smsRow = ../../SMS/FS-720-HDS-010-SDS-020-SMS-020;
      miniSmtIds = [ "endpoint-harness-consumption" ];
      inputKinds = [ "intent-source" ];
    };
    "FS-720-HDS-010-SDS-020-SMS-040" = {
      smsRow = ../../SMS/FS-720-HDS-010-SDS-020-SMS-040;
      miniSmtIds = [ "row-local" ];
      inputKinds = [ "source-reference" ];
      evidenceBoundary = "construction-only";
    };
  };
  templateTests = [
    "tests/test-gamp-sds-sms-template-mapping.sh"
    "tests/test-active-lab-mini-smt-sds-input-templates.sh"
    "tests/test-active-lab-mini-smt-sms-input-templates.sh"
  ];
}
