{
  layer = "SIT";
  traceId = "FS-166-HDS-010-SDS-010";
  smsInputs = {
    "FS-166-HDS-010-SDS-010-SMS-900" = {
      smsRow = ../../SMS/FS-166-HDS-010-SDS-010-SMS-900;
      smtRow = ../../SMT/FS-166-HDS-010-SDS-010-SMS-900;
      sourcePath = "GAMP/SMS/FS-166-HDS-010-SDS-010-SMS-900/default.nix";
      role = "renderer-mini-smt-umbrella";
    };
  };
  evidence = {
    command = "tests/run-active-lab-mini-smt.sh renderer-nixos renderer-nixos-p2p renderer-nixos-clients renderer-clab renderer-wireguard renderer-nebula";
    liveCommand = "cd /home/deadbeef/github/network-codex-agent && NETWORK_REPO_DIRECT_TEST_OK=1 NETWORK_LABS_PATH=/home/deadbeef/github/network-labs NETWORK_RENDERER_NIXOS_PATH=/home/deadbeef/github/network-renderer-nixos S_ROUTER_NIXOS=192.168.1.17 S_ROUTER_CLAB=192.168.1.19 S_ROUTER_TEST_CLIENTS=192.168.1.18 bash scripts/fs166-active-lab-renderer-nixos-runtime-check.sh --live";
    liveP2pCommand = "cd /home/deadbeef/github/network-codex-agent && NETWORK_REPO_DIRECT_TEST_OK=1 NETWORK_LABS_PATH=/home/deadbeef/github/network-labs NETWORK_RENDERER_NIXOS_PATH=/home/deadbeef/github/network-renderer-nixos S_ROUTER_NIXOS=192.168.1.17 S_ROUTER_CLAB=192.168.1.19 S_ROUTER_TEST_CLIENTS=192.168.1.18 bash scripts/fs166-active-lab-renderer-nixos-p2p-runtime-check.sh --live";
    liveClientsCommand = "cd /home/deadbeef/github/network-codex-agent && NETWORK_REPO_DIRECT_TEST_OK=1 NETWORK_LABS_PATH=/home/deadbeef/github/network-labs NETWORK_RENDERER_ACCESS_ENDPOINT_NIXOS_PATH=/home/deadbeef/github/network-renderer-access-endpoint-nixos S_ROUTER_NIXOS=192.168.1.17 S_ROUTER_CLAB=192.168.1.19 S_ROUTER_TEST_CLIENTS=192.168.1.18 bash scripts/fs166-active-lab-renderer-nixos-clients-runtime-check.sh --live";
    sourcePaths = [
      "GAMP/SMT/FS-166-HDS-010-SDS-010-SMS-900/runtime-nixos-cpm.nix"
      "GAMP/SMT/FS-166-HDS-010-SDS-010-SMS-900/runtime-nixos-p2p-cpm.nix"
      "GAMP/SMT/FS-166-HDS-010-SDS-010-SMS-900/renderer-input/minimal-access-endpoint-cpm.nix"
      "GAMP/SMT/FS-166-HDS-010-SDS-010-SMS-900/renderer-input/minimal-clab-cpm.nix"
      "GAMP/SMT/FS-166-HDS-010-SDS-010-SMS-900/renderer-input/wireguard-provider-contract.nix"
      "GAMP/SMT/FS-166-HDS-010-SDS-010-SMS-900/renderer-input/minimal-nebula-cpm.nix"
    ];
    observedResult = "2026-06-27: renderer mini-SMT entries independently runnable with explicit CPM inputs; command exited 0 for renderer-nixos, renderer-nixos-p2p, renderer-nixos-clients, renderer-clab, renderer-wireguard, and renderer-nebula. SMT/SIT prerequisite evidence only; no HAT/SAT runtime acceptance claim.";
    liveObservedResult = "2026-06-30: renderer-nixos active-lab live verifier exited 0 after selecting network-labs@b077ad6 current-lab SMT renderer-nixos and local nixos lock 56239c47. Local builds passed for s-router-nixos (/nix/store/3x94j69vaz05ahhvxw4c3c0ynlc36c24-nixos-system-s-router-nixos-26.05.20260627.714a5f8), s-router-clab (/nix/store/m2y4zy7bkp4rj6bz7n6k252l323m2nfa-nixos-system-s-router-clab-26.05.20260627.714a5f8), and s-router-test-clients (/nix/store/kw8m11ib6xqkw739qshci20jkdiq503j-nixos-system-s-router-test-clients-26.05.20260627.714a5f8). The three s-router hosts were shut down and returned through the external rebuild path. Live s-router-nixos reported the FS-166 renderer-input artifact and running poc-router; live s-router-clab and s-router-test-clients reported the same FS-166 artifact with poc-router not running on those hosts. Row-local SMT/SIT runtime evidence only; no HAT/SAT acceptance claim.";
    liveP2pObservedResult = "2026-06-30: renderer-nixos-p2p active-lab live verifier exited 0 after network-labs@50850a3 selected current-lab SMT renderer-nixos-p2p, network-labs@f9d21d2 completed the renderer-input CPM fixture, and local nixos lock 5f86907b consumed it. Local builds passed for s-router-nixos (/nix/store/9d37x0mj3kdzz3p3fdpplyd4zxbjmayk-nixos-system-s-router-nixos-26.05.20260627.714a5f8), s-router-clab (/nix/store/sfj8f085hqsqzs5daf9dxiz97yadm7wx-nixos-system-s-router-clab-26.05.20260627.714a5f8), and s-router-test-clients (/nix/store/x1rb1r0dwv7bqfzkddl41p7bxq3p3b0s-nixos-system-s-router-test-clients-26.05.20260627.714a5f8). The three s-router hosts were shut down and returned through the external rebuild path. Live s-router-nixos reported the FS-166 p2p renderer-input artifact, running edge-a and edge-b, and the rendered p2p bridge; live s-router-clab and s-router-test-clients reported the same FS-166 p2p artifact with edge-a and edge-b not running on those hosts. Row-local SMT/SIT runtime evidence only; no HAT/SAT acceptance claim.";
    liveClientsObservedResult = "2026-06-30: renderer-nixos-clients active-lab live verifier exited 0 after network-labs@d494c16 selected current-lab SMT renderer-nixos-clients, removed router runtime targets from the endpoint fixture, and local nixos lock c75190e5 consumed it. Local builds passed for s-router-nixos (/nix/store/6vvzch7wpwdhszs8d75xri8vbbdkl5ii-nixos-system-s-router-nixos-26.05.20260627.714a5f8), s-router-clab (/nix/store/46zis36qs3r0p19vr8inrmnwa4pkn4n0-nixos-system-s-router-clab-26.05.20260627.714a5f8), and s-router-test-clients (/nix/store/0b9hns2pz369q36nmhr9f8x8hwhv2aj2-nixos-system-s-router-test-clients-26.05.20260627.714a5f8). The three s-router hosts were shut down and returned through the external rebuild path. Live s-router-test-clients reported the FS-166 clients control-plane artifact, access-endpoint provenance for poc-client, rendered client bridge, and running container@poc-client.service; live s-router-nixos and s-router-clab reported poc-client absent. Row-local SMT/SIT runtime evidence only; no HAT/SAT acceptance claim.";
  };
}
