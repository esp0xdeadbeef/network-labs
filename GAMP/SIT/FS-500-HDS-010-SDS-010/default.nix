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
    command = "tests/run-active-lab-mini-smt.sh reachability-decision decision-reason-diagnostic p2p-next-hop";
    liveCommand = "NETWORK_REPO_DIRECT_TEST_OK=1 S_ROUTER_NIXOS=192.168.1.17 S_ROUTER_CLAB=192.168.1.19 S_ROUTER_TEST_CLIENTS=192.168.1.18 ../network-codex-agent/scripts/fs500-active-lab-reachability-runtime-check.sh --live";
    sourcePaths = [
      "GAMP/SMT/FS-500-HDS-010-SDS-010-SMS-010/intent.nix"
      "GAMP/SMT/FS-500-HDS-010-SDS-010-SMS-040/intent.nix"
    ];
    observedResult = "focused mini runner verifies the SDS with explicit row-local SMS inputs without full HAT/SAT deployment. Live verifier must prove the selected reachability-decision active-lab renders exactly the five-node client-edge, downstream-selector, policy, upstream-selector, testnet-edge path on NixOS and CLAB while s-router-test-clients remains client-only.";
  };
}
