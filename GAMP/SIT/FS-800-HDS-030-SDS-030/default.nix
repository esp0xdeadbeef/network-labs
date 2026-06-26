{
  layer = "SIT";
  traceId = "FS-800-HDS-030-SDS-030";
  smsInputs = {
    "FS-800-HDS-030-SDS-030-SMS-010" = {
      smtRow = ../../SMT/FS-800-HDS-030-SDS-030-SMS-010;
      sourcePath = "GAMP/SMT/FS-800-HDS-030-SDS-030-SMS-010/intent.nix";
      role = "pppoe-provider-customer-pairing";
    };
    "FS-800-HDS-030-SDS-030-SMS-040" = {
      smtRow = ../../SMT/FS-800-HDS-030-SDS-030-SMS-040;
      role = "hat-script-override-rejection";
      evidenceBoundary = "construction-only";
    };
  };
  evidence = {
    command = "tests/run-active-lab-mini-smt.sh pppoe-pairing";
    sourcePath = "GAMP/SMT/FS-800-HDS-030-SDS-030-SMS-010/intent.nix";
    observedResult = "focused mini runner verifies PPPoE provider/customer pairing without full HAT/SAT deployment";
  };
}
