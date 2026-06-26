{
  layer = "SMS";
  traceId = "FS-800-HDS-010-SDS-030-SMS-040";
  parentSds = ../../SDS/FS-800-HDS-010-SDS-030;
  purpose = "HAT Script Override Rejection (construction-only).";
  evidenceBoundary = "construction-only";
  sourceInputs = {};
  templateTests = [
    "tests/test-gamp-sds-sms-template-mapping.sh"
  ];
}
