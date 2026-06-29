# SIT Integration Fixture: FS-800-HDS-030-SDS-020

Status: OK - focused source, CPM contract, and renderer artifact tests pass.

Evidence command:

```bash
network_labs_path="${PWD}";
bash tests/FS-800-HDS-030-SDS-020-SMS-010-pppoe-customer-side-source.sh &&
(cd ../network-control-plane-model && NETWORK_LABS_PATH="${network_labs_path}" NETWORK_REPO_DIRECT_TEST_OK=1 bash tests/FS-800-HDS-030-SDS-010-SMS-010-pppoe-service-interface-contract.sh) &&
(cd ../network-renderer-containerlab-linux-backend && NETWORK_REPO_DIRECT_TEST_OK=1 bash tests/test-fs800-hds030-sds010-sms010-pppoe-artifacts.sh)
```

This SDS-scoped SIT row verifies the network-labs HAT/SAT provider-access
fixtures carry customer-side PPPoE source records, ppp0 runtime interface
expectations, default-route and peer-DNS client behavior, and credential
references, then verifies the current CPM and CLAB renderer consume those
records into explicit `pppoe-handoff` interfaces and a rendered Containerlab
bridge link. Live PPPoE session acceptance remains HAT/SAT scope.
