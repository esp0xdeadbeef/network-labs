{
  layer = "SDS";
  traceId = "FS-820-HDS-010-SDS-010";
  purpose = "Canonical SMS mirror grouping with active-lab runtime artifact coverage for runnable SMS inputs.";
  smsInputs = {
    "FS-820-HDS-010-SDS-010-SMS-010" = {
      smsRow = ../../SMS/FS-820-HDS-010-SDS-010-SMS-010;
      miniSmtIds = [ "canonical-source-stub" ];
      inputKinds = [ "source-reference" ];
      evidenceBoundary = "source-stub-only";
    };
    "FS-820-HDS-010-SDS-010-SMS-020" = {
      smsRow = ../../SMS/FS-820-HDS-010-SDS-010-SMS-020;
      miniSmtIds = [ "canonical-source-stub" ];
      inputKinds = [ "source-reference" ];
      evidenceBoundary = "source-stub-only";
    };
    "FS-820-HDS-010-SDS-010-SMS-030" = {
      smsRow = ../../SMS/FS-820-HDS-010-SDS-010-SMS-030;
      miniSmtIds = [ "canonical-source-stub" ];
      inputKinds = [ "source-reference" ];
      evidenceBoundary = "source-stub-only";
    };
    "FS-820-HDS-010-SDS-010-SMS-050" = {
      smsRow = ../../SMS/FS-820-HDS-010-SDS-010-SMS-050;
      miniSmtIds = [ "FS-820-HDS-010-SDS-010-SMS-050" ];
      inputKinds = [ "intent-source" ];
      evidenceBoundary = "active-lab-mini-smt-runtime-artifact";
      expectedRuntimeTargets = {
        "s-router-nixos" = 5;
        "s-router-clab" = 5;
        "s-router-test-clients" = 0;
      };
    };
    "FS-820-HDS-010-SDS-010-SMS-060" = {
      smsRow = ../../SMS/FS-820-HDS-010-SDS-010-SMS-060;
      miniSmtIds = [ "canonical-source-stub" ];
      inputKinds = [ "source-reference" ];
      evidenceBoundary = "source-stub-only";
    };
  };
}
