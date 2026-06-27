{
  layer = "SMT";
  traceId = "FS-030-HDS-010-SDS-030-SMS-010";
  evidenceBoundary = "construction-only";
  source = null;
  evidence = {
    owningRepo = "network-compiler";
    focusedTest = "tests/test-fs030-hds010-sds030-sms010-compiler-boundary.sh";
    smtRow = "GAMP/SMT/README.md row for FS-030-HDS-010-SDS-030-SMS-010";
    status = "NOT OK";
    scope = "Compiler overlay-underlay separation: enforces distinct policy relations with separate p2pIsolationKey per overlay leg, requires explicit underlayAccess declarations, emits forbidsCoreToCoreP2P and overlay/peer-site identity";
  };
}
