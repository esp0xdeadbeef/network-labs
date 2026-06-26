{
  layer = "SMS";
  traceId = "FS-840-HDS-010-SDS-010-SMS-040";
  parentSds = ../../SDS/FS-840-HDS-010-SDS-010;
  purpose = "Impermanence-Safe Early SOPS Delivery (construction-only).";
  evidenceBoundary = "construction-only";
  sourceInputs = {};
  templateTests = [
    "tests/test-gamp-sds-sms-template-mapping.sh"
  ];
}
