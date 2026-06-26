{
  layer = "SMT";
  traceId = "FS-030-HDS-010-SDS-010-SMS-040";
  evidenceBoundary = "construction-only";
  source = null;
  evidence = {
    owningRepo = "network-control-plane-model";
    focusedTest = "tests/test-cpm-realization-binder-source-audit.sh";
    smtRow = "GAMP/SMT/README.md row for FS-030-HDS-010-SDS-010-SMS-040";
    status = "NOT OK";
    scope = "CPM binder source audit: ensures every CPM realization-binding field carries a binder source-class audit reference plus upstream behavior reference, fails closed on missing or cross-stage audit records";
  };
}
