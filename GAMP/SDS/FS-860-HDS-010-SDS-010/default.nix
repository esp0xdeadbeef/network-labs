{
  layer = "SDS";
  traceId = "FS-860-HDS-010-SDS-010";
  purpose = "Canonical SMS mirror grouping with active-lab runtime artifact coverage for runnable SMS inputs.";
  smsInputs = {
    "FS-860-HDS-010-SDS-010-SMS-010" = {
      smsRow = ../../SMS/FS-860-HDS-010-SDS-010-SMS-010;
      miniSmtIds = [ "canonical-source-stub" ];
      inputKinds = [ "source-reference" ];
      evidenceBoundary = "source-stub-only";
    };
    "FS-860-HDS-010-SDS-010-SMS-020" = {
      smsRow = ../../SMS/FS-860-HDS-010-SDS-010-SMS-020;
      miniSmtIds = [ "canonical-source-stub" ];
      inputKinds = [ "source-reference" ];
      evidenceBoundary = "source-stub-only";
    };
    "FS-860-HDS-010-SDS-010-SMS-030" = {
      smsRow = ../../SMS/FS-860-HDS-010-SDS-010-SMS-030;
      miniSmtIds = [ "FS-860-HDS-010-SDS-010-SMS-030" ];
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
    "tests/test-gamp-canonical-sms-mirror.sh"
    "tests/test-active-lab-runtime-artifact-sms-sit-boundary.sh"
  ];
}
