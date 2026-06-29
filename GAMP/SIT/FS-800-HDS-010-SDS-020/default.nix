{
  layer = "SIT";
  traceId = "FS-800-HDS-010-SDS-020";
  smsInputs = {
    "FS-800-HDS-010-SDS-020-SMS-040" = {
      smtRow = ../../SMT/FS-800-HDS-010-SDS-020-SMS-040;
      sourcePath = "GAMP/SMT/FS-800-HDS-010-SDS-020-SMS-040/intent.nix";
      role = "provider-access-default-route";
    };
  };
  evidence = {
    command = "bash tests/FS-800-HDS-010-SDS-020-SMS-040-provider-access-default-route.sh";
    sourcePaths = [
      "GAMP/SMT/FS-800-HDS-010-SDS-020-SMS-040/intent.nix"
    ];
    observedResult = "2026-06-29: row-local provider-access default-route structural test passed; construction/local-build evidence only, live provider-handoff egress remains HAT-routed.";
  };
}
