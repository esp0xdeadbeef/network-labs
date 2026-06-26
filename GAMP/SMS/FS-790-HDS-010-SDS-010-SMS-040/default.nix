{
  layer = "SMS";
  traceId = "FS-790-HDS-010-SDS-010-SMS-040";
  parentSds = ../../SDS/FS-790-HDS-010-SDS-010;
  purpose = "Public Ingress Provider And Emulation Boundary (construction-only).";
  evidenceBoundary = "construction-only";
  sourceInputs = {};
  templateTests = [
    "tests/test-gamp-sds-sms-template-mapping.sh"
  ];
}
