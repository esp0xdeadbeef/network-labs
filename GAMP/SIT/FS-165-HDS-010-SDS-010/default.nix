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
      sourcePath = "GAMP/SMT/FS-165-HDS-010-SDS-010-SMS-020/intent.nix";
      role = "readable-normalized-source-form";
      evidenceBoundary = "construction-only";
    };
    "FS-165-HDS-010-SDS-010-SMS-030" = {
      smtRow = ../../SMT/FS-165-HDS-010-SDS-010-SMS-030;
      sourcePath = "GAMP/SMT/FS-165-HDS-010-SDS-010-SMS-030/intent.nix";
      role = "downstream-contract-gap-diagnostic";
    };
  };
  evidence = {
    command = "bash tests/test-fs165-hds010-sds010-sms010-source-value-necessity.sh";
    repo = "network-labs with network-codex-agent checker";
    sourcePaths = [
      "GAMP/SMT/FS-165-HDS-010-SDS-010-SMS-010/intent.nix"
      "network-codex-agent/scripts/helpers/gamp-sms-input-contracts.py"
    ];
    observedResult = "2026-06-29: row-local source fixture plus network-codex-agent checker passed source-form minimality predicates for SMS-010/020/030 cases; source-to-construction evidence only.";
    scope = "source-form review: SMS-010 necessity + SMS-020 readability + SMS-030 gap diagnostics";
  };
}
