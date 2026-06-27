{
  layer = "SMT";
  traceId = "FS-340-HDS-010-SDS-010-SMS-010";
  evidenceBoundary = "construction-only";
  source = null;
  evidence = {
    owningRepo = "network-control-plane-model";
    focusedTest = "tests/FS-970-HDS-010-SDS-010-SMS-020-static-reservation-offset-resolution.sh";
    smtRow = "GAMP/SMT/README.md row 133";
    status = "NOT OK";
    verifiedAt = "network-control-plane-model HEAD c0e9ee1 (2026-06-17, verified by sms-specialist-042)";
    scope = "IPv4 decimal offset parsing: consumes offset + subnet + scope, rejects non-decimal syntax (SN1: 0x0A hex), rejects out-of-range offsets (SN2: offset 300 > /24 max 254).";
  };
}
