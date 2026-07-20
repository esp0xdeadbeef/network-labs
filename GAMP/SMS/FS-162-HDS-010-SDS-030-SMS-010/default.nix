{
  layer = "SMS";
  traceId = "FS-162-HDS-010-SDS-030-SMS-010";
  parentSds = ../../SDS/FS-162-HDS-010-SDS-030;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-162-HDS-010-SDS-030-SMS-010-openconfig-cpm-interface-parsing-fail-closed.md";
  titleSlug = "openconfig-canonical-interface-parsing-fail-closed";
  purpose = "Validated canonical interface mapping with explicit provenance and fail-closed negatives.";
  evidenceBoundary = "construction-only";
  sourceInputs.canonicalBundle = {
    kind = "validated-canonical-bundle";
    formerDirectCpmFixture = {
      classification = "negative-only";
      expectedDiagnostic = "OC_RAW_CPM_INPUT";
      expectedExit = 2;
    };
  };
}
