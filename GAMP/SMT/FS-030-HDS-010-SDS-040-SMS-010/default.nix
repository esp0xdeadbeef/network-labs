{
  layer = "SMT";
  traceId = "FS-030-HDS-010-SDS-040-SMS-010";
  evidenceBoundary = "construction-only";
  source = null;
  evidence = {
    owningRepo = "network-compiler";
    focusedTest = "tests/test-fs030-hds010-sds040-sms010-compiler-boundary.sh";
    smtRow = "GAMP/SMT/README.md row for FS-030-HDS-010-SDS-040-SMS-010";
    status = "NOT OK";
    scope = "Compiler platform independence contract: refuses renderer-specific, deployment-platform-specific, or vendor-specific concepts in compiler output; rejects intent fields selecting specific renderers or technologies";
  };
}
