# SIT Integration Fixture: FS-800-HDS-030-SDS-020

Status: OK - focused source, CPM contract, renderer artifact tests, and live
customer-side PPPoE session markers pass on the active HAT lab.

Evidence command:

```bash
network_labs_path="${PWD}";
bash tests/FS-800-HDS-030-SDS-020-SMS-010.sh &&
bash ../network-codex-agent/tests/FS-800-HDS-030-SDS-020-SMS-010.sh &&
(cd ../network-control-plane-model && NETWORK_LABS_PATH="${network_labs_path}" NETWORK_REPO_DIRECT_TEST_OK=1 bash tests/FS-800-HDS-030-SDS-010-SMS-010.sh) &&
(cd ../network-renderer-containerlab-linux-backend &&
  NETWORK_REPO_DIRECT_TEST_OK=1 bash tests/test-fs800-hds030-sds010-sms010-target-host-bridge-scope.sh &&
  NETWORK_REPO_DIRECT_TEST_OK=1 bash tests/test-fs800-hds030-sds010-sms010-pppoe-artifacts.sh) &&
bash tests/FS-800-HDS-030-SDS-020-SIT-live-pppoe-session-markers.sh
```

This SDS-scoped SIT row verifies the network-labs HAT/SAT provider-access
fixtures carry customer-side PPPoE source records, ppp0 runtime interface
expectations, default-route and peer-DNS client behavior, and credential
references, then verifies the current CPM and CLAB renderer consume those
records into explicit `pppoe-handoff` interfaces and a rendered Containerlab
bridge link.

Live row evidence on 2026-06-29 after renderer fixes:

```bash
S_ROUTER_NIXOS=192.168.1.17 \
S_ROUTER_CLAB=192.168.1.19 \
S_ROUTER_TEST_CLIENTS=192.168.1.18 \
  ../network-codex-agent/scripts/live-FS-800-HDS-030-SDS-030-SMS-010.sh --live
```

The live verifier passes end-to-end against active-lab HAT hosts:
`FS-800-HDS-020-SDS-021` secret materialization, provider-side PPPoE runtime,
customer-side PPPoE runtime, and the CLAB live render marker all pass. The NixOS
host was reached at `192.168.1.17` because lab DNS was unavailable after the
activation; the running generation was
`/nix/store/r347n2c5lwwbhc2l9rpzw82a058parzz-nixos-system-s-router-nixos-26.05.20260627.714a5f8`.
The owning NixOS renderer fixes are `network-renderer-nixos@55727d3` (non-blocking
PPPoE client starter) and `network-renderer-nixos@f763a1d` (timer-delayed client
start after container host bridge attachment). Live evidence showed
`nixos-core-testnet-host-isp` with `ppp0` at `203.0.113.4/32` and
`nixos-core-testnet-routed-isp` with `ppp1` at `203.0.113.2 peer
203.0.113.1/32`.
