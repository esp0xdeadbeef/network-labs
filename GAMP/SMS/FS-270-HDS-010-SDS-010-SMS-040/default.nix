{
  layer = "SMS";
  traceId = "FS-270-HDS-010-SDS-010-SMS-040";
  parentSds = ../../SDS/FS-270-HDS-010-SDS-010;
  purpose = "Selector Handoff Transport Forwarding Boundary (construction-only). Validates that selector routers emit only modeled handoff and transport forwarding with relation identity, rejecting unlabeled broad forwarding from local interface fanout.";
  evidenceBoundary = "construction-only";
  sourceInputs = {};
  templateTests = [
    "tests/test-gamp-sds-sms-template-mapping.sh"
  ];
}
