{
  layer = "SIT";
  traceId = "FS-050-HDS-010-SDS-010";
  smsInputs = {
    "FS-050-HDS-010-SDS-010-SMS-010" = {
      smtRow = ../../SMT/FS-050-HDS-010-SDS-010-SMS-010;
      sourcePath = "GAMP/SMT/FS-050-HDS-010-SDS-010-SMS-010/intent.nix";
      role = "protected-inventory-boundary";
      evidenceBoundary = "construction-only";
    };
  };
  evidence = {
    observedResult = "SMT row NOT OK — no dedicated RaTM test at CPM HEAD. SIT integration path declared for end-to-end inventory boundary verification alongside FS-040 and FS-030.";
  };
}
