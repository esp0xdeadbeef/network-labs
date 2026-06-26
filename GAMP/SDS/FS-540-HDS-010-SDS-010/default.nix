{
  layer = "SDS";
  traceId = "FS-540-HDS-010-SDS-010";
  purpose = "DNS resolver config mini POC input grouping.";
  smsInputs = {
    "FS-540-HDS-010-SDS-010-SMS-020" = {
      smsRow = ../../SMS/FS-540-HDS-010-SDS-010-SMS-020;
      miniSmtIds = [ "dns-resolver-config" ];
      inputKinds = [ "intent-source" ];
    };
    "FS-540-HDS-010-SDS-010-SMS-040" = {
      smsRow = ../../SMS/FS-540-HDS-010-SDS-010-SMS-040;
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
