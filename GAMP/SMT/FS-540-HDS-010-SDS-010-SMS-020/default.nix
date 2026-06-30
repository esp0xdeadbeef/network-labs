{
  layer = "SMT";
  traceId = "FS-540-HDS-010-SDS-010-SMS-020";
  miniSmtId = "dns-resolver-config";
  source = {
    kind = "intent-source";
    intent = ./intent.nix;
    expectedRelationIds = [
      "FS-540-HDS-010-SDS-010-SMS-020__mini-client-to-access-dns"
      "FS-540-HDS-010-SDS-010-SMS-020__mini-access-dns-service-to-testnet"
      "FS-540-HDS-010-SDS-010-SMS-020__mini-dns-client-to-testnet"
    ];
  };
  evidence = {
    command = "tests/run-active-lab-mini-smt.sh dns-resolver-config";
    focusedTest = "tests/test-active-lab-mini-smt-dns-resolver-config-only.sh";
    liveSitProbe = "tests/FS-540-HDS-010-SDS-010-SIT-live-recursive-dns.sh";
    liveCommand = ''
      cd /home/deadbeef/github/network-codex-agent &&
      NETWORK_REPO_DIRECT_TEST_OK=1 \
      NETWORK_LABS_PATH=/home/deadbeef/github/network-labs \
      NETWORK_CPM_PATH=/home/deadbeef/github/network-control-plane-model \
      NETWORK_RENDERER_NIXOS_PATH=/home/deadbeef/github/network-renderer-nixos \
      NETWORK_RENDERER_ACCESS_ENDPOINT_NIXOS_PATH=/home/deadbeef/github/network-renderer-access-endpoint-nixos \
      NETWORK_RENDERER_CLAB_PATH=/home/deadbeef/github/network-renderer-containerlab-linux-backend \
      S_ROUTER_NIXOS=192.168.1.17 \
      S_ROUTER_CLAB=192.168.1.19 \
      S_ROUTER_TEST_CLIENTS=192.168.1.18 \
      bash scripts/fs540-active-lab-dns-resolver-runtime-check.sh --live
    '';
    maxRuntimeTargets = 5;
    scope = "CPM per-interface DNS resolver configuration authority over the smallest requester-policy-resolver path: access-dns, downstream-selector, policy, upstream-selector, resolver-node";
    observedResult = "OK live on 2026-06-30: row-local tests and the live FS-540 active-lab DNS verifier passed. The SMT source selects the five-node resolver path, emits local-recursive/dhcp-provided/no-public-fallback resolver-source authority, requires the row-local s-router-test-clients endpoint source, and proves that s-router-test-clients renders the dns-resolver-config-access-dns endpoint without router containers. Runtime proof on 192.168.1.17 and 192.168.1.19 resolves cache.nixos.org from access-dns through the modeled recursive path; 192.168.1.18 runs the endpoint-only container/bridge needed by this row.";
  };
}
