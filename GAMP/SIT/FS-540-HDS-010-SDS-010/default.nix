{
  layer = "SIT";
  traceId = "FS-540-HDS-010-SDS-010";
  smsInputs = {
    "FS-540-HDS-010-SDS-010-SMS-020" = {
      smtRow = ../../SMT/FS-540-HDS-010-SDS-010-SMS-020;
      sourcePath = "GAMP/SMT/FS-540-HDS-010-SDS-010-SMS-020/intent.nix";
      role = "dns-resolver-config";
    };
    "FS-540-HDS-010-SDS-010-SMS-040" = {
      smtRow = ../../SMT/FS-540-HDS-010-SDS-010-SMS-040;
      sourcePath = "GAMP/SMT/FS-540-HDS-010-SDS-010-SMS-040/intent.nix";
      role = "requester-lane-recursive-reachability";
      evidenceBoundary = "construction-only";
    };
    "FS-540-HDS-010-SDS-010-SMS-045" = {
      smtRow = ../../SMT/FS-540-HDS-010-SDS-010-SMS-045;
      sourcePath = "GAMP/SMT/FS-540-HDS-010-SDS-010-SMS-045/intent.nix";
      role = "prod-like-access-recursive-dns";
      evidenceBoundary = "source-stub-plus-live-script";
    };
    "FS-540-HDS-010-SDS-010-SMS-010" = {
      smtRow = ../../SMT/FS-540-HDS-010-SDS-010-SMS-010;
      sourcePath = "GAMP/SMT/FS-540-HDS-010-SDS-010-SMS-010/intent.nix";
      role = "row-local-source-stub";
      evidenceBoundary = "source-stub-only";
    };
};
  evidence = {
    command = ''
      tests/run-active-lab-mini-smt.sh FS-540-HDS-010-SDS-010-SMS-020 &&
      tests/run-active-lab-mini-smt.sh FS-540-HDS-010-SDS-010-SMS-045 &&
      tests/FS-540-HDS-010-SDS-010-SIT-live-recursive-dns.sh
    '';
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
    sourcePaths = [
      "GAMP/SMT/FS-540-HDS-010-SDS-010-SMS-020/intent.nix"
      "GAMP/SMT/FS-540-HDS-010-SDS-010-SMS-020/intent-test-clients.nix"
      "GAMP/SMT/FS-540-HDS-010-SDS-010-SMS-045/intent.nix"
      "GAMP/SMT/FS-540-HDS-010-SDS-010-SMS-045/intent-test-clients.nix"
      "GAMP/SMT/FS-540-HDS-010-SDS-010-SMS-045/inventory-nixos.nix"
      "GAMP/SMT/FS-540-HDS-010-SDS-010-SMS-045/inventory-clab.nix"
      "GAMP/SMT/FS-540-HDS-010-SDS-010-SMS-045/inventory-test-clients.nix"
    ];
    observedResult = "OK live on 2026-06-30: fs540-active-lab-dns-resolver-runtime-check.sh --live passed against 192.168.1.17/s-router-nixos, 192.168.1.19/s-router-clab, and 192.168.1.18/s-router-test-clients. The row-local test-client source now materializes only dns-resolver-config-access-dns on s-router-test-clients with no router runtime targets, and the live host has container@dns-resolver-config-access-dns.service active with bridge br-mini--baff8b UP. Both router surfaces expose the five-node mini path access-dns, downstream-selector, policy, upstream-selector, resolver-node; resolver-source counts are local-recursive=1, upstream-forwarder=0, dhcp-provided=1, none=9, public-fallback=0. CLAB fake-provider runtime has gateway/NAT/upstream reachability, upstream-selector runtime-origin policy route selects p1 with scoped return rule to 10.54.10.0/24, and access-dns recursive DNS resolves cache.nixos.org on both NixOS and CLAB without Docker/host public resolver fallback. 2026-07-03: child FS-540-HDS-010-SDS-010-SMS-045 passed the locked active-lab full loop with S_ROUTER_ACTIVE_LAB_TRACE_ID=FS-540-HDS-010-SDS-010-SMS-045 and evidence directory /tmp/s-router-live-smoke/FS-540-HDS-010-SDS-010-SMS-045/20260703T200952Z. Manual enumeration proved prod-like-dns-client01 and prod-like-dns-clab-client01 route via 10.54.45.1, use link DNS 10.54.45.1, resolve cache.nixos.org through the access DNS service, and trace through access-vlan2, downstream-selector, policy, upstream-selector, and core. This is FS-540 SMT/SIT evidence only and does not claim HAT, SAT, or production readiness.";
  };
}
