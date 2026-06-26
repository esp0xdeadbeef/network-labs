{
  layer = "SMS";
  traceId = "FS-350-HDS-010-SDS-010-SMS-040";
  parentSds = ../../SDS/FS-350-HDS-010-SDS-010;
  purpose = "Prefix authority class separation: classify each prefix by authority class, preserve host-only vs delegated/client distinction, emit consumer eligibility records (construction-only).";
  evidenceBoundary = "construction-only";
  sourceInputs = {};
  templateTests = [
    "tests/test-gamp-sds-sms-template-mapping.sh"
  ];
}
