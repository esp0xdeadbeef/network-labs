{
  layer = "SMS";
  traceId = "FS-162-HDS-010-SDS-010-SMS-010";
  parentSds = ../../SDS/FS-162-HDS-010-SDS-010;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-162-HDS-010-SDS-010-SMS-010-openconfig-instance-document-emission.md";
  titleSlug = "openconfig-instance-document-emission";
  purpose = "Canonical-bundle to RFC 7951 OpenConfig instance construction proof.";
  evidenceBoundary = "construction-only";
  sourceInputs.canonicalBundle = {
    kind = "validated-canonical-bundle";
    firstActiveBoundary = "network-renderer-openconfig";
    seededNegativeCases = [
      "OC_RAW_CPM_INPUT"
      "OC_REQUIRED_CANONICAL_FIELD_MISSING"
      "OC_CANONICAL_PATH_UNMAPPED"
      "OC_TYPE_IDENTITY_UNMAPPED"
      "OC_PEER_RENDERER_CONSUMED"
      "OC_RENDERER_DEFAULT_INVENTED"
      "OC_OUTPUT_WITHOUT_PROVENANCE"
      "OC_YANG_VALIDATION_FAILED"
    ];
  };
}
