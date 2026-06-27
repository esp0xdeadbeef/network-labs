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
    "FS-500-HDS-010-SDS-010-SMS-020" = {
      smsRow = ../../SMS/FS-500-HDS-010-SDS-010-SMS-020;
      miniSmtIds = [ "row-local" ];
      inputKinds = [ "intent-source" ];
      evidenceBoundary = "source-stub-only";
    };
    "FS-500-HDS-010-SDS-010-SMS-030" = {
      smsRow = ../../SMS/FS-500-HDS-010-SDS-010-SMS-030;
      miniSmtIds = [ "decision-reason-diagnostic" ];
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
