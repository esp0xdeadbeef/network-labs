{
  layer = "SMS";
  traceId = "FS-620-HDS-010-SDS-010-SMS-040";
  parentSds = ../../SDS/FS-620-HDS-010-SDS-010;
  purpose = "Implied Client Path Rejection Module (construction-only).";
  evidenceBoundary = "construction-only";
  sourceInputs = {};
  templateTests = [
    "tests/test-gamp-sds-sms-template-mapping.sh"
  ];
}
