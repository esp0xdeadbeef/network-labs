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
    observedResult = "2026-06-30: NETWORK_REPO_DIRECT_TEST_OK=1 S_ROUTER_NIXOS=192.168.1.17 S_ROUTER_CLAB=192.168.1.19 S_ROUTER_TEST_CLIENTS=192.168.1.18 ../network-codex-agent/scripts/fs800-provider-default-route-active-lab-runtime-check.sh --live PASS. Row-local SMT/SIT source uses current selectable active-lab semantics; the stale 2026-06-29 ppp0-default-route expectation was not the provider-handoff route contract. Live s-router-nixos and s-router-clab probes verified provider-handoff-access-a default route via fabric gateway 10.80.255.2 on p0 with provider address 203.0.113.1 and no PPP leak, while pppoe-core default route stayed isolated on uplink u0. s-router-test-clients was reachable and remained a client-only surface for this row.";
  };
}
