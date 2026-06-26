{
  layer = "SIT";
  traceId = "FS-165-HDS-010-SDS-010";
  smsInputs = {
    "FS-165-HDS-010-SDS-010-SMS-010" = {
      smtRow = ../../SMT/FS-165-HDS-010-SDS-010-SMS-010;
      sourcePath = "GAMP/SMT/FS-165-HDS-010-SDS-010-SMS-010/README.md";
      role = "source-value-necessity";
    };
    "FS-165-HDS-010-SDS-010-SMS-020" = {
      smtRow = ../../SMT/FS-165-HDS-010-SDS-010-SMS-020;
      sourcePath = "GAMP/SMS/FS-165-HDS-010-SDS-010-SMS-020-readable-normalized-source-form.md";
      role = "readable-normalized-source-form";
    };
    "FS-165-HDS-010-SDS-010-SMS-030" = {
      smtRow = ../../SMT/FS-165-HDS-010-SDS-010-SMS-030;
      sourcePath = "GAMP/SMS/FS-165-HDS-010-SDS-010-SMS-030-downstream-contract-gap-diagnostic.md";
      role = "downstream-contract-gap-diagnostic";
    };
  };
  evidence = {
    command = "bash tests/test-gamp-fs165-source-form-minimality.sh";
    repo = "network-codex-agent";
    sourcePaths = [
      "GAMP/SMS/FS-165-HDS-010-SDS-010-SMS-010-source-value-necessity.md"
      "GAMP/SMS/FS-165-HDS-010-SDS-010-SMS-020-readable-normalized-source-form.md"
      "GAMP/SMS/FS-165-HDS-010-SDS-010-SMS-030-downstream-contract-gap-diagnostic.md"
    ];
    observedResult = "Shared construction test covers all three SMS siblings for source-form review pipeline";
    scope = "source-form review: SMS-010 necessity + SMS-020 readability + SMS-030 gap diagnostics";
  };
}
