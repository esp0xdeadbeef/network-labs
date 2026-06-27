{
  layer = "SMS";
  traceId = "FS-350-HDS-010-SDS-010-SMS-050";
  parentSds = ../../SDS/FS-350-HDS-010-SDS-010;
  purpose = "Inventory realization cross-ledger diagnostics: realize overlay participant-address assignments from NFM ledger into CPM inventory, emit cross-ledger and identity-mutation diagnostics (construction-only, CPM-owned).";
  evidenceBoundary = "construction-only";
  sourceInputs = {};
  templateTests = [
    "tests/test-gamp-sds-sms-template-mapping.sh"
  ];
}
