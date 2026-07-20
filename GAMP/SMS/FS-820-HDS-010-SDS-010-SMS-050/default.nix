{
  layer = "SMS";
  traceId = "FS-820-HDS-010-SDS-010-SMS-050";
  parentSds = ../../SDS/FS-820-HDS-010-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-820-HDS-010-SDS-010-SMS-050-network-labs-sops-configuration-validation.md";
  titleSlug = "network-labs-sops-configuration-validation";
  purpose = "Canonical SMS mirror with active-lab SMT/SIT runtime artifact validation.";
  evidenceBoundary = "active-lab-mini-smt-runtime-artifact";
  sourceInputs = {
    "FS-820-HDS-010-SDS-010-SMS-050" = {
      traceId = "FS-820-HDS-010-SDS-010-SMS-050";
      kind = "intent-source";
      sourcePath = "GAMP/SMT/FS-820-HDS-010-SDS-010-SMS-050/intent.nix";
      expectedRuntimeTargets = {
        "s-router-nixos" = 5;
        "s-router-clab" = 5;
        "s-router-test-clients" = 0;
      };
      maxRuntimeTargets = 5;
    };
  };
}
