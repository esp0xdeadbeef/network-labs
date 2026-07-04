{
  layer = "SIT";
  traceId = "FS-030-HDS-010-SDS-040";
  smsInputs = {
    "FS-030-HDS-010-SDS-040-SMS-010" = {
      smtRow = ../../SMT/FS-030-HDS-010-SDS-040-SMS-010;
      sourcePath = "GAMP/SMT/FS-030-HDS-010-SDS-040-SMS-010/intent.nix";
      role = "row-local-mini-smt";
      evidenceBoundary = "row-local-mini-smt";
    };
  };
  evidence = {
    command = "MINI_SMT_OFFLINE_VERIFY=0 bash tests/run-active-lab-mini-smt.sh FS-030-HDS-010-SDS-040-SMS-010";
    lockedNetworkLabsRev = "6c85977ee6dbff2148a141e84988754fec7dba15";
    sourcePaths = [
      "GAMP/SMT/FS-030-HDS-010-SDS-040-SMS-010/intent.nix"
    ];
    observedResult = "2026-07-04 live closure passed against locked active-lab artifacts on s-router-nixos, s-router-clab, and s-router-test-clients; offline verifier skipped; pinned s-router-nixos build passed";
    evidenceDirs = [
      "/tmp/s-router-live-smoke/FS-030-HDS-010-SDS-040-SMS-010/20260704T053321Z"
      "/tmp/s-router-live-smoke/FS-030-HDS-010-SDS-040-SMS-010/20260704T053649Z"
      "/tmp/active-lab-mini-smt-runs/20260704T053642Z-2913672/FS-030-HDS-010-SDS-040-SMS-010"
    ];
  };
}
