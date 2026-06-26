{
  layer = "SMS";
  traceId = "FS-830-HDS-010-SDS-010-SMS-040";
  parentSds = ../../SDS/FS-830-HDS-010-SDS-010;
  purpose = "SOPS Bootstrap Identity Transport for nixos-anywhere (construction-only).";
  evidenceBoundary = "construction-only";
  sourceInputs = {};
  templateTests = [
    "tests/test-gamp-sds-sms-template-mapping.sh"
  ];
}
