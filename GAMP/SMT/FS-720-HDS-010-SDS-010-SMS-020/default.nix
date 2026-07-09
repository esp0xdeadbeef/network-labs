{
  layer = "SMT";
  traceId = "FS-720-HDS-010-SDS-010-SMS-020";
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-720-HDS-010-SDS-010-SMS-020-test-clients-assignment-address.md";
  titleSlug = "test-clients-assignment-address";
  source = {
    kind = "canonical-sms-source-stub";
    sourcePath = "GAMP/SMT/FS-720-HDS-010-SDS-010-SMS-020/intent.nix";
    inventories = {
      clab = "GAMP/SMT/FS-720-HDS-010-SDS-010-SMS-020/inventory-clab.nix";
      nixos = "GAMP/SMT/FS-720-HDS-010-SDS-010-SMS-020/inventory-nixos.nix";
      testClients = "GAMP/SMT/FS-720-HDS-010-SDS-010-SMS-020/inventory-test-clients.nix";
    };
    evidenceBoundary = "construction-and-live-context";
  };
  status = "OK";
  evidence = {
    command = "NETWORK_REPO_DIRECT_TEST_OK=1 bash tests/test-fs720-hds010-sds010-sms020-assignment-address.sh";
    focusedTest = "tests/test-fs720-hds010-sds010-sms020-assignment-address.sh";
    observedResult = "PASS — SMS predicate coverage matrix 18/18: MR1 tenant/assignment validation, MR2 address identity validation, MR3 authority rejection, CI1-CI2 consumed interfaces, EI1-EI3 emitted interfaces, FC1 missing assignment/address/tenant/gateway failures, FC2 DNS/route authority from assignment rejected, SN1 route authority from node IP rejected, SN2 DNS/NAT authority from node address rejected, CH1 construction handoff. Mini-SMT live PASS: s-router-nixos (192.168.1.17) and s-router-clab (192.168.1.19) online, pinned nixos-shell build PASS. s-router-test-clients (192.168.1.18) online with vlan2 bridge up.";
  };
}
