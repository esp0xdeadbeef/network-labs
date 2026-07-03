{
  layer = "SIT";
  traceId = "FS-020-HDS-010-SDS-010";
  smsInputs = {
    "FS-020-HDS-010-SDS-010-SMS-010" = {
      smtRow = ../../SMT/FS-020-HDS-010-SDS-010-SMS-010;
      sourcePath = "GAMP/SMT/FS-020-HDS-010-SDS-010-SMS-010/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-020-HDS-010-SDS-010-SMS-010-source-class-assignment.md";
      role = "row-local-mini-smt";
      evidenceBoundary = "row-local-mini-smt";
    };
  };
  evidence = {
    command = "tests/run-active-lab-mini-smt.sh FS-020-HDS-010-SDS-010-SMS-010";
    observedResult = "row-local mini-SMT registered; live closure requires locked active-lab artifacts on s-router-nixos, s-router-clab, and s-router-test-clients";
  };
}
