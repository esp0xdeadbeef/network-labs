# SIT Integration Fixture: FS-800-HDS-030-SDS-020

Status: NOT OK - focused source, CPM contract, and renderer artifact tests
pass, but live customer-side PPPoE session markers are absent.

Evidence command:

```bash
network_labs_path="${PWD}";
bash tests/FS-800-HDS-030-SDS-020-SMS-010-pppoe-customer-side-source.sh &&
bash ../network-codex-agent/tests/FS-800-HDS-030-SDS-020-SMS-010-pppoe-customer-side-record-checks.sh &&
(cd ../network-control-plane-model && NETWORK_LABS_PATH="${network_labs_path}" NETWORK_REPO_DIRECT_TEST_OK=1 bash tests/FS-800-HDS-030-SDS-010-SMS-010-pppoe-service-interface-contract.sh) &&
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

Live row evidence on 2026-06-29:

```bash
bash tests/FS-800-HDS-030-SDS-020-SIT-live-pppoe-session-markers.sh
```

The customer-side source/CPM/renderer fixtures pass and the live NixOS secret
materialization probe passes, but `bash
tests/FS-800-HDS-030-SDS-020-SIT-live-pppoe-session-markers.sh` fails on
`s-router-nixos`: `nixos-core-testnet-host-isp` is stuck `activating` after a
targeted start attempt and `nixos-core-testnet-routed-isp` is `inactive`; the
customer PPPoE session is not established. The CLAB
customer-side PPPoE containers do have live `ppp0`/`ppp1` PPP links and pppd
client processes, so the remaining current gap is NixOS customer-side PPPoE
activation.
