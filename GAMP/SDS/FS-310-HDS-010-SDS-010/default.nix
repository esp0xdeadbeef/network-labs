{
  layer = "SDS";
  traceId = "FS-310-HDS-010-SDS-010";
  purpose = "Policy router relation identity mini POC input grouping.";
  smsInputs = {
    "FS-310-HDS-010-SDS-010-SMS-030" = {
      smsRow = ../../SMS/FS-310-HDS-010-SDS-010-SMS-030;
      miniSmtIds = [ "policy-router-relation-identity" ];
      inputKinds = [ "intent-source" ];
    };
    "FS-310-HDS-010-SDS-010-SMS-010" = {
      smsRow = ../../SMS/FS-310-HDS-010-SDS-010-SMS-010;
      miniSmtIds = [ "row-local" ];
      inputKinds = [ "intent-source" ];
      evidenceBoundary = "source-stub-only";
    };
};
  templateTests = [
    "tests/test-gamp-sds-sms-template-mapping.sh"
    "tests/test-active-lab-mini-smt-sds-input-templates.sh"
    "tests/test-active-lab-mini-smt-sms-input-templates.sh"
  ];
}
