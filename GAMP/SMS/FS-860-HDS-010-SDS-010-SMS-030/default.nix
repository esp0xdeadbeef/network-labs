{
  layer = "SMS";
  traceId = "FS-860-HDS-010-SDS-010-SMS-030";
  parentSds = ../../SDS/FS-860-HDS-010-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-860-HDS-010-SDS-010-SMS-030-scoped-storage-binding-emission.md";
  titleSlug = "scoped-storage-binding-emission";
  purpose = "Canonical SMS mirror with active-lab SMT/SIT runtime artifact validation.";
  evidenceBoundary = "active-lab-mini-smt-runtime-artifact";
  sourceInputs = {
    "FS-860-HDS-010-SDS-010-SMS-030" = {
      traceId = "FS-860-HDS-010-SDS-010-SMS-030";
      kind = "intent-source";
      sourcePath = "GAMP/SMT/FS-860-HDS-010-SDS-010-SMS-030/intent.nix";
      expectedRuntimeTargets = {
        "s-router-nixos" = 5;
        "s-router-clab" = 5;
        "s-router-test-clients" = 0;
      };
      maxRuntimeTargets = 5;
    };
  };
}
