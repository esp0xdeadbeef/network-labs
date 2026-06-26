{
  layer = "SMT";
  traceId = "FS-050-HDS-010-SDS-010-SMS-010";
  evidenceBoundary = "construction-only";
  source = null;
  evidence = {
    owningRepo = "network-control-plane-model";
    cmcModule = "src/cpm/binder-source-audit.nix";
    smtRow = "GAMP/SMT/README.md row 108";
    status = "NOT OK";
    gap = "No dedicated construction test carries FS-050-HDS-010-SDS-010-SMS-010 trace-chain ID. Existing SMT evidence cites FS-030 test.";
    scope = "CPM protected-inventory boundary: unauthorized consumer rejection, plaintext leak prevention, redacted reference emission";
  };
}
