{
  layer = "SDS";
  traceId = "FS-500-HDS-010-SDS-010";
  purpose = "Active-lab reachability and p2p mini POC input grouping.";
  smsInputs = {
    "FS-500-HDS-010-SDS-010-SMS-010" = {
      smsRow = ../../SMS/FS-500-HDS-010-SDS-010-SMS-010;
      miniSmtIds = [ "reachability-decision" ];
      inputKinds = [ "intent-source" ];
    };

    "FS-500-HDS-010-SDS-010-SMS-040" = {
      smsRow = ../../SMS/FS-500-HDS-010-SDS-010-SMS-040;
      miniSmtIds = [ "p2p-next-hop" ];
      inputKinds = [ "intent-source" ];
    };
  };
  templateTests = [
    "tests/test-gamp-sds-sms-template-mapping.sh"
    "tests/test-active-lab-mini-smt-sds-input-templates.sh"
    "tests/test-active-lab-mini-smt-sms-input-templates.sh"
  ];
}
