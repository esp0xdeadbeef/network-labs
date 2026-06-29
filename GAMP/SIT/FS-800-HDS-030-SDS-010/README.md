# SIT Integration Fixture: FS-800-HDS-030-SDS-010

Status: OK - focused source, CPM contract, renderer artifact tests, and live
provider-side PPPoE runtime checks pass.

Evidence command:

```bash
network_labs_path="${PWD}";
bash tests/FS-800-HDS-030-SDS-010-SMS-010-pppoe-provider-side-source.sh &&
(cd ../network-control-plane-model && NETWORK_LABS_PATH="${network_labs_path}" NETWORK_REPO_DIRECT_TEST_OK=1 bash tests/FS-800-HDS-030-SDS-010-SMS-010-pppoe-service-interface-contract.sh) &&
(cd ../network-renderer-containerlab-linux-backend &&
  NETWORK_REPO_DIRECT_TEST_OK=1 bash tests/test-fs800-hds030-sds010-sms010-target-host-bridge-scope.sh &&
  NETWORK_REPO_DIRECT_TEST_OK=1 bash tests/test-fs800-hds030-sds010-sms010-pppoe-artifacts.sh) &&
bash tests/FS-800-HDS-030-SDS-010-SIT-live-pppoe-session-markers.sh
```

This SDS-scoped SIT row verifies the network-labs HAT/SAT provider-access
fixtures carry provider-side PPPoE source records, isolated HAT bridge
selection, provider service records, and credential references, then verifies
the current CPM and CLAB renderer consume those records into explicit
`pppoe-handoff` interfaces and a rendered Containerlab bridge link.

Live row evidence on 2026-06-29:

```bash
bash tests/FS-800-HDS-030-SDS-010-SIT-live-pppoe-session-markers.sh
```

The provider-side source/CPM/renderer fixtures pass, CLAB render has a live
success marker, and `bash
tests/FS-800-HDS-030-SDS-010-SIT-live-pppoe-session-markers.sh` passes. The live
probe verifies `s-router-nixos` and `s-router-clab` expose provider/customer
PPPoE records and that provider-side PPPoE server/runtime processes are active.
