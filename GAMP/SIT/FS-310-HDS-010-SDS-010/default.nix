{
  layer = "SIT";
  traceId = "FS-310-HDS-010-SDS-010";
  smsInputs = {
    "FS-310-HDS-010-SDS-010-SMS-030" = {
      smtRow = ../../SMT/FS-310-HDS-010-SDS-010-SMS-030;
      sourcePath = "GAMP/SMT/FS-310-HDS-010-SDS-010-SMS-030/intent.nix";
      role = "policy-router-relation-identity";
    };
    "FS-310-HDS-010-SDS-010-SMS-010" = {
      smtRow = ../../SMT/FS-310-HDS-010-SDS-010-SMS-010;
      sourcePath = "GAMP/SMT/FS-310-HDS-010-SDS-010-SMS-010/intent.nix";
      role = "row-local-source-stub";
      evidenceBoundary = "source-stub-only";
    };
};
  evidence = {
    command = "bash tests/test-fs310-hds010-sds010-sms030-policy-router-relation-identity-row-local.sh";
    sourcePaths = [
      "GAMP/SMT/FS-310-HDS-010-SDS-010-SMS-030/intent.nix"
    ];
    observedResult = "2026-06-29: row-local structural SMT/SIT proof passed for relation identity preservation without shared mini-SMT manifest registration or HAT/SAT deployment.";
  };
}
