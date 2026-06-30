{
  layer = "SIT";
  traceId = "FS-500-HDS-010-SDS-010";
  smsInputs = {
    "FS-500-HDS-010-SDS-010-SMS-010" = {
      smtRow = ../../SMT/FS-500-HDS-010-SDS-010-SMS-010;
      sourcePath = "GAMP/SMT/FS-500-HDS-010-SDS-010-SMS-010/intent.nix";
      role = "reachability-decision-result";
    };

    "FS-500-HDS-010-SDS-010-SMS-040" = {
      smtRow = ../../SMT/FS-500-HDS-010-SDS-010-SMS-040;
      sourcePath = "GAMP/SMT/FS-500-HDS-010-SDS-010-SMS-040/intent.nix";
      role = "p2p-next-hop-pairing";
    };
    "FS-500-HDS-010-SDS-010-SMS-020" = {
      smtRow = ../../SMT/FS-500-HDS-010-SDS-010-SMS-020;
      sourcePath = "GAMP/SMT/FS-500-HDS-010-SDS-010-SMS-020/intent.nix";
      role = "row-local-source-stub";
      evidenceBoundary = "source-stub-only";
    };
    "FS-500-HDS-010-SDS-010-SMS-030" = {
      smtRow = ../../SMT/FS-500-HDS-010-SDS-010-SMS-030;
      sourcePath = "GAMP/SMT/FS-500-HDS-010-SDS-010-SMS-030/intent.nix";
      role = "row-local-source-stub";
      evidenceBoundary = "source-stub-only";
    };
};
  evidence = {
    command = "tests/run-active-lab-mini-smt.sh FS-500-HDS-010-SDS-010-SMS-010 FS-500-HDS-010-SDS-010-SMS-030 FS-500-HDS-010-SDS-010-SMS-040";
    liveCommand = "row-specific live verifiers: fs500-active-lab-reachability-runtime-check.sh --live; fs500-decision-reason-active-lab-runtime-check.sh --live; fs500-p2p-next-hop-active-lab-runtime-check.sh --live";
    sourcePaths = [
      "GAMP/SMT/FS-500-HDS-010-SDS-010-SMS-010/intent.nix"
      "GAMP/SMT/FS-500-HDS-010-SDS-010-SMS-040/intent.nix"
    ];
    observedResult = "2026-06-30: focused mini runner verifies the SDS with explicit row-local SMS inputs without full HAT/SAT deployment. Live verifiers passed for reachability-decision, decision-reason-diagnostic, and p2p-next-hop against s-router-nixos 192.168.1.17 and s-router-clab 192.168.1.19. Reachability and decision-reason rows exposed exactly client-edge, downstream-selector, policy, upstream-selector, and testnet-edge; p2p-next-hop exposed exactly router-a, downstream-selector, policy, upstream-selector, and router-b. s-router-test-clients 192.168.1.18 remained a client/substrate surface with no row router containers.";
  };
}
