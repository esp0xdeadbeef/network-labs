{
  layer = "SIT";
  traceId = "FS-050-HDS-010-SDS-010";
  smsInputs = {
    "FS-050-HDS-010-SDS-010-SMS-010" = {
      smtRow = ../../SMT/FS-050-HDS-010-SDS-010-SMS-010;
      sourcePath = "GAMP/SMT/FS-050-HDS-010-SDS-010-SMS-010/default.nix";
      role = "protected-inventory-boundary";
      evidenceBoundary = "construction-only";
    };
  };
  evidence = {
    observedResult = "SMT construction row OK at network-control-plane-model commit 8c0cafd. SIT remains a construction-only integration declaration for protected inventory boundary composition alongside FS-040 and FS-030; no runtime topology is claimed.";
  };
}
