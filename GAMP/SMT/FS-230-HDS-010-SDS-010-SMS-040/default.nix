{
  layer = "SMT";
  traceId = "FS-230-HDS-010-SDS-010-SMS-040";
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-230-HDS-010-SDS-010-SMS-040-s-router-prod-nebula-ipv6-ingress-compatibility.md";
  titleSlug = "native-nebula-ipv6-public-ingress-tuple-materialization";
  source = {
    kind = "intent-and-inventory-construction-candidate";
    sourcePath = "GAMP/SMT/FS-230-HDS-010-SDS-010-SMS-040/intent.nix";
    inventories = {
      clab = "GAMP/SMT/FS-230-HDS-010-SDS-010-SMS-040/inventory-clab.nix";
      nixos = "GAMP/SMT/FS-230-HDS-010-SDS-010-SMS-040/inventory-nixos.nix";
      testClients = "GAMP/SMT/FS-230-HDS-010-SDS-010-SMS-040/inventory-test-clients.nix";
    };
    evidenceBoundary = "construction-green-live-cold-stage-pending";
  };
  status = "NOT OK";
  evidence = {
    command = "NETWORK_REPO_DIRECT_TEST_OK=1 tests/FS-230-HDS-010-SDS-010-SMS-040-native-protected-ipv6-ingress.sh";
    focusedTest = "network-control-plane-model/tests/FS-230-HDS-010-SDS-010-SMS-040-nebula-ipv6-public-ingress.sh; network-renderer-nixos/tests/FS-230-HDS-010-SDS-010-SMS-040-nebula-ipv6-public-ingress.sh; network-renderer-containerlab-linux-backend/tests/test-fs230-hds010-sds010-sms040-nebula-ipv6-public-ingress.sh";
    observedResult = "The pushed construction candidate preserves the address-free IPv6 UDP/4242 intent tuple, derives provider surface and endpoint from inventory, and emits equivalent protected-runtime NixOS and CLAB contracts. The row remains NOT OK until exact consumer pins and an isolated three-host cold stage prove the live tuple and stateful return without a hotpatch.";
  };
}
