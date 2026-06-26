{
  layer = "SMS";
  traceId = "FS-960-HDS-010-SDS-010-SMS-040";
  parentSds = ../../SDS/FS-960-HDS-010-SDS-010;
  purpose = "Long Running Readiness Status Marker (construction-only).";
  evidenceBoundary = "construction-only";
  sourceInputs = {};
  templateTests = [
    "tests/test-gamp-sds-sms-template-mapping.sh"
  ];
}
