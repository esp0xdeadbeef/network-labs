{
  layer = "SMS";
  traceId = "FS-830-HDS-010-SDS-010-SMS-040";
  parentSds = ../../SDS/FS-830-HDS-010-SDS-010;
  purpose = "SOPS Bootstrap Identity Transport for nixos-anywhere with active-lab SMT/SIT runtime artifact validation.";
  evidenceBoundary = "active-lab-mini-smt-runtime-artifact";
  sourceInputs = {
    "FS-830-HDS-010-SDS-010-SMS-040" = {
      traceId = "FS-830-HDS-010-SDS-010-SMS-040";
      kind = "intent-source";
      sourcePath = "GAMP/SMT/FS-830-HDS-010-SDS-010-SMS-040/intent.nix";
      test = "../network-codex-agent/scripts/smt-live-FS-830-HDS-010-SDS-010-SMS-040.sh";
      expectedRuntimeTargets = {
        "s-router-nixos" = 5;
        "s-router-clab" = 5;
        "s-router-test-clients" = 0;
      };
      maxRuntimeTargets = 5;
    };
  };
  templateTests = [
    "tests/test-gamp-sds-sms-template-mapping.sh"
    "tests/test-active-lab-runtime-artifact-sms-sit-boundary.sh"
  ];
}
