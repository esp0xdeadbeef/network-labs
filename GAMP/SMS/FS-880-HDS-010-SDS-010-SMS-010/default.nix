{
  layer = "SMS";
  traceId = "FS-880-HDS-010-SDS-010-SMS-010";
  parentSds = ../../SDS/FS-880-HDS-010-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-880-HDS-010-SDS-010-SMS-010-lease-namespace-ownership.md";
  titleSlug = "lease-namespace-ownership";
  purpose = "Canonical SMS mirror with active-lab SMT/SIT runtime artifact validation.";
  evidenceBoundary = "active-lab-mini-smt-runtime-artifact";
  sourceInputs = {
    "FS-880-HDS-010-SDS-010-SMS-010" = {
      traceId = "FS-880-HDS-010-SDS-010-SMS-010";
      kind = "intent-source";
      sourcePath = "GAMP/SMT/FS-880-HDS-010-SDS-010-SMS-010/intent.nix";
      expectedRuntimeTargets = {
        "s-router-nixos" = 5;
        "s-router-clab" = 5;
        "s-router-test-clients" = 0;
      };
      maxRuntimeTargets = 5;
    };
  };
}
