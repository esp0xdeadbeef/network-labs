{
  layer = "SIT";
  traceId = "FS-030-HDS-010-SDS-030";
  smsInputs = {
    "FS-030-HDS-010-SDS-030-SMS-010" = {
      smtRow = ../../SMT/FS-030-HDS-010-SDS-030-SMS-010;
      sourcePath = "GAMP/SMT/FS-030-HDS-010-SDS-030-SMS-010/intent.nix";
      canonicalSms = "network-codex-agent/GAMP/SMS/FS-030-HDS-010-SDS-030-SMS-010-overlay-underlay-separation.md";
      role = "row-local-mini-smt";
      evidenceBoundary = "row-local-mini-smt";
    };
  };
  evidence = {
    observedResult = "2026-07-04 live closure passed against locked active-lab artifacts on s-router-nixos, s-router-clab, and s-router-test-clients; offline verifier skipped; pinned s-router-nixos build passed";
    lockedNetworkLabsRev = "e755869dd1d11a3a96d08c5ea933ba23456150c7";
    evidenceDirs = [
      "/tmp/s-router-live-smoke/FS-030-HDS-010-SDS-030-SMS-010/20260704T051250Z"
      "/tmp/s-router-live-smoke/FS-030-HDS-010-SDS-030-SMS-010/20260704T051319Z"
      "/tmp/active-lab-mini-smt-runs/20260704T051312Z-2891933/FS-030-HDS-010-SDS-030-SMS-010"
    ];
  };
}
