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
      sourcePath = "GAMP/SMT/FS-800-HDS-030-SDS-030-SMS-040/intent.nix";
      role = "hat-script-override-rejection";
      evidenceBoundary = "construction-only";
    };
  };
  evidence = {
    command = "tests/run-active-lab-mini-smt.sh pppoe-pairing";
    liveCommand = "NETWORK_REPO_DIRECT_TEST_OK=1 S_ROUTER_NIXOS=192.168.1.17 S_ROUTER_CLAB=192.168.1.19 S_ROUTER_TEST_CLIENTS=192.168.1.18 ../network-codex-agent/scripts/fs800-pppoe-pairing-active-lab-runtime-check.sh --live";
    sourcePath = "GAMP/SMT/FS-800-HDS-030-SDS-030-SMS-010/intent.nix";
    observedResult = "2026-06-30: focused mini runner verifies PPPoE provider/customer pairing, fallback rejection, transport classification, and the selectable five-node current-lab runtime shape without full HAT/SAT deployment. Live verifier passed against s-router-nixos 192.168.1.17 and s-router-clab 192.168.1.19 with exactly downstream-selector, policy, pppoe-client, pppoe-provider, and upstream-selector; s-router-test-clients 192.168.1.18 remained client-only with no PPPoE pairing router containers.";
  };
}
