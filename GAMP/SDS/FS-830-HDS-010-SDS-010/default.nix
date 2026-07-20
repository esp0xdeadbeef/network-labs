{
  layer = "SDS";
  traceId = "FS-830-HDS-010-SDS-010";
  purpose = "FS-830-HDS-010-SDS-010 software design with active-lab runtime artifact validation.";
  smsInputs = {
    "FS-830-HDS-010-SDS-010-SMS-040" = {
      smsRow = ../../SMS/FS-830-HDS-010-SDS-010-SMS-040;
      miniSmtIds = [ "FS-830-HDS-010-SDS-010-SMS-040" ];
      inputKinds = [ "intent-source" ];
      evidenceBoundary = "active-lab-mini-smt-runtime-artifact";
      expectedRuntimeTargets = {
        "s-router-nixos" = 5;
        "s-router-clab" = 5;
        "s-router-test-clients" = 0;
      };
    };
  };
}
