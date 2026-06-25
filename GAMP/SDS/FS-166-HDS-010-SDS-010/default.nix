{
  layer = "SDS";
  traceId = "FS-166-HDS-010-SDS-010";
  purpose = "Active-lab renderer-entry mini POC input grouping.";
  smsInputs = {
    "FS-166-HDS-010-SDS-010-SMS-900" = {
      smsRow = ../../SMS/FS-166-HDS-010-SDS-010-SMS-900;
      miniSmtIds = [
        "renderer-nixos"
        "renderer-nixos-p2p"
        "renderer-nixos-clients"
        "renderer-clab"
        "renderer-wireguard"
        "renderer-nebula"
      ];
      inputKinds = [ "renderer-input" ];
    };
  };
  templateTests = [
    "tests/test-gamp-sds-sms-template-mapping.sh"
    "tests/test-active-lab-mini-smt-sds-input-templates.sh"
    "tests/test-active-lab-mini-smt-sms-input-templates.sh"
  ];
}
