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
    observedResult = "2026-06-30: focused mini runner verifies PPPoE provider/customer pairing, fallback rejection, transport classification, and the selectable five-node current-lab runtime shape without full HAT/SAT deployment. Live verifier must prove the deployed NixOS and CLAB surfaces expose exactly the five current-lab runtime targets and that s-router-test-clients remains client-only for this row.";
  };
}
