{
  layer = "SMS";
  traceId = "FS-162-HDS-010-SDS-040-SMS-010";
  parentSds = ../../SDS/FS-162-HDS-010-SDS-040;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-162-HDS-010-SDS-040-SMS-010-s-router-prod-comparable-projection.md";
  titleSlug = "s-router-prod-comparable-projection";
  purpose = "Direct OpenConfig construction proof for the isolated FS-230 CPM posture.";
  evidenceBoundary = "construction-only";
  sourceInputs = {
    "fs230-openconfig-posture" = {
      traceId = "FS-162-HDS-010-SDS-040-SMS-010";
      kind = "isolated-fs230-cpm";
      sourcePath = "GAMP/SMT/FS-162-HDS-010-SDS-040-SMS-010/intent.nix";
      test = "tests/FS-162-HDS-010-SDS-040-SMS-010-s-router-prod-comparable-projection.sh";
      maxRuntimeTargets = 0;
    };
  };
  templateTests = [
    "tests/FS-162-HDS-010-SDS-040-SMS-010-s-router-prod-comparable-projection.sh"
  ];
}
