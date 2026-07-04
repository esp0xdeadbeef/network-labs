{
  layer = "SDS";
  traceId = "FS-840-HDS-010-SDS-010";
  purpose = "FS-840-HDS-010-SDS-010 software design with active-lab runtime artifact validation.";
  smsInputs = {
    "FS-840-HDS-010-SDS-010-SMS-040" = {
      smsRow = ../../SMS/FS-840-HDS-010-SDS-010-SMS-040;
      miniSmtIds = [ "FS-840-HDS-010-SDS-010-SMS-040" ];
      inputKinds = [ "intent-source" ];
      evidenceBoundary = "active-lab-mini-smt-runtime-artifact";
      expectedRuntimeTargets = {
        "s-router-nixos" = 5;
        "s-router-clab" = 5;
        "s-router-test-clients" = 0;
      };
    };
  };
  templateTests = [
    "tests/test-gamp-sds-sms-template-mapping.sh"
    "tests/test-active-lab-runtime-artifact-sms-sit-boundary.sh"
  ];
}
