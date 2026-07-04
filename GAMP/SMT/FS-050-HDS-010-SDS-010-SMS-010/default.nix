{
  layer = "SMT";
  traceId = "FS-050-HDS-010-SDS-010-SMS-010";
  evidenceBoundary = "construction-only";
  source = null;
  evidence = {
    owningRepo = "network-control-plane-model";
    cmcModule = "src/cpm/secret-source-contract.nix";
    focusedTest = "tests/FS-050-HDS-010-SDS-010-SMS-010-protected-inventory-boundary.sh";
    cpmCommit = "8c0cafd";
    smtRow = "GAMP/SMT/README.md FS-050-HDS-010-SDS-010-SMS-010";
    status = "OK";
    scope = "CPM protected-inventory boundary: unauthorized consumer rejection, plaintext leak prevention, redacted reference emission";
  };
}
