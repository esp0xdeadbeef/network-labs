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
    observedResult = "NOT OK on the current revised atom. Historical 2026-06-30 and 2026-07-03 public-name runs proved an earlier IPv4 path only. Cold restage14 on 2026-07-18 proved that NixOS materializes the selected resolver-identity UDP/TCP port-53 rules and emits upstream packets, but external root behavior determined the result. That is invalid evidence for reproducible multi-egress DNS. Acceptance remains open until both NixOS and CLAB complete first-attempt dual-stack UDP/TCP recursion against the staged controlled authoritative hierarchy on only the selected provider, with no public or host resolver dependency.";
  };
}
