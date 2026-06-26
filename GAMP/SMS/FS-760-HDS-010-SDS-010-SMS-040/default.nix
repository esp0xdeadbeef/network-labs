{
  layer = "SMS";
  traceId = "FS-760-HDS-010-SDS-010-SMS-040";
  parentSds = ../../SDS/FS-760-HDS-010-SDS-010;
  purpose = "Receiver Tenant And Management Denial (construction-only).";
  evidenceBoundary = "construction-only";
  sourceInputs = {};
  templateTests = [
    "tests/test-gamp-sds-sms-template-mapping.sh"
  ];
}
