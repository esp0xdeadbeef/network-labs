{
  layer = "SMS";
  traceId = "FS-162-HDS-010-SDS-020-SMS-010";
  parentSds = ../../SDS/FS-162-HDS-010-SDS-020;
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-162-HDS-010-SDS-020-SMS-010-openconfig-yang-model-validation.md";
  titleSlug = "openconfig-yang-model-validation";
  purpose = "Offline locked YANG validation of the emitted OpenConfig instance.";
  evidenceBoundary = "construction-only";
  sourceInputs.candidateInstance = {
    kind = "openconfig-rfc7951-candidate";
    expectedFailureDiagnostic = "OC_YANG_VALIDATION_FAILED";
    expectedYangFailureExit = 3;
    networkAccess = false;
  };
}
