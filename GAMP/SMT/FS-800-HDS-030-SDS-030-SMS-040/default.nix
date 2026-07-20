{
  layer = "SMT";
  traceId = "FS-800-HDS-030-SDS-030-SMS-040";
  evidenceBoundary = "construction-only";
  source = {
    kind = "intent-source";
    intent = ./intent.nix;
  };
  evidence = {
    owningRepo = "network-labs";
    status = "NOT OK";
    scope = "Row-local SMT/SIT source stub exists so the SMS can be addressed by the controlled network-labs source tree.";
  };
}
