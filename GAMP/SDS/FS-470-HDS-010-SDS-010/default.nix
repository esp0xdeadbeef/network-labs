{
  layer = "SDS";
  traceId = "FS-470-HDS-010-SDS-010";
  purpose = "FS-470-HDS-010-SDS-010 software design — WireGuard remote-egress provider runtime integration.";
  smsInputs = {
    "FS-470-HDS-010-SDS-010-SMS-010" = {
      smsRow = ../../SMS/FS-470-HDS-010-SDS-010-SMS-010;
      miniSmtIds = [ "wireguard-remote-egress" ];
      inputKinds = [ "renderer-input" ];
      evidenceBoundary = "active-lab mini SMT/SIT";
    };
    "FS-470-HDS-010-SDS-010-SMS-040" = {
      smsRow = ../../SMS/FS-470-HDS-010-SDS-010-SMS-040;
      miniSmtIds = [ "row-local" ];
      inputKinds = [ "source-reference" ];
      evidenceBoundary = "construction-only";
    };
  };
  templateTests = [
    "tests/test-gamp-sds-sms-template-mapping.sh"
  ];
}
