{
  layer = "SMS";
  traceId = "FS-970-HDS-010-SDS-010-SMS-040";
  parentSds = ../../SDS/FS-970-HDS-010-SDS-010;
  purpose = "Static Reservation Renderer Record Boundary with active-lab SMT/SIT runtime artifact validation.";
  evidenceBoundary = "active-lab-mini-smt-runtime-artifact";
  sourceInputs = {
    "FS-970-HDS-010-SDS-010-SMS-040" = {
      traceId = "FS-970-HDS-010-SDS-010-SMS-040";
      kind = "intent-source";
      sourcePath = "GAMP/SMT/FS-970-HDS-010-SDS-010-SMS-040/intent.nix";
      expectedRuntimeTargets = {
        "s-router-nixos" = 5;
        "s-router-clab" = 5;
        "s-router-test-clients" = 0;
      };
      maxRuntimeTargets = 5;
    };
  };
}
