{
  layer = "SIT";
  traceId = "FS-030-HDS-010-SDS-020";
  smsInputs = {
    "FS-030-HDS-010-SDS-020-SMS-010" = {
      smtRow = ../../SMT/FS-030-HDS-010-SDS-020-SMS-010;
      sourcePath = "GAMP/SMT/FS-030-HDS-010-SDS-020-SMS-010/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-030-HDS-010-SDS-020-SMS-010-stage-topology-enforcement.md";
      role = "row-local-mini-smt";
      evidenceBoundary = "row-local-mini-smt";
    };
  };
  evidence = {
    command = "tests/run-active-lab-mini-smt.sh --source FS-030-HDS-010-SDS-020-SMS-010";
    observedResult = "row-local mini-SMT registered; live closure requires locked active-lab artifacts on s-router-nixos, s-router-clab, and s-router-test-clients";
  };
}
