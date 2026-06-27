{
  layer = "SMS";
  traceId = "FS-440-HDS-010-SDS-010-SMS-040";
  parentSds = ../../SDS/FS-440-HDS-010-SDS-010;
  purpose = "Commercial VPN Authority Boundary Software Module Specification (construction-only).";
  evidenceBoundary = "construction-only";
  sourceInputs = {
    "row-local" = {
      traceId = "FS-440-HDS-010-SDS-010-SMS-040";
      kind = "intent-source";
      sourcePath = "GAMP/SMT/FS-440-HDS-010-SDS-010-SMS-040/intent.nix";
      test = "tests/test-gamp-row-source-stubs.sh";
      maxRuntimeTargets = 0;
    };
  };
  templateTests = [
    "tests/test-gamp-sds-sms-template-mapping.sh"
  ];
}
