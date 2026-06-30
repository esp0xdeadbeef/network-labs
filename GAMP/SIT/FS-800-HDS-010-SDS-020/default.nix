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
    command = "tests/run-active-lab-mini-smt.sh provider-access-default-route";
    liveCommand = "NETWORK_REPO_DIRECT_TEST_OK=1 S_ROUTER_NIXOS=192.168.1.17 S_ROUTER_CLAB=192.168.1.19 S_ROUTER_TEST_CLIENTS=192.168.1.18 ../network-codex-agent/scripts/fs800-provider-default-route-active-lab-runtime-check.sh --live";
    sourcePaths = [
      "GAMP/SMT/FS-800-HDS-010-SDS-020-SMS-040/intent.nix"
    ];
    observedResult = "2026-06-30: row-local SMT/SIT source now uses current selectable active-lab semantics. The stale 2026-06-29 ppp0-default-route expectation was not the provider-handoff route contract; the small current-lab source proves provider-handoff default selection through the canonical access -> downstream-selector -> policy -> upstream-selector -> fabric-core path while keeping the PPPoE-side core out of default-reachability.";
  };
}
