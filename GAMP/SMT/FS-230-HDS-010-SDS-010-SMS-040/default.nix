{
  layer = "SMT";
  traceId = "FS-230-HDS-010-SDS-010-SMS-040";
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-230-HDS-010-SDS-010-SMS-040-s-router-prod-nebula-ipv6-ingress-compatibility.md";
  titleSlug = "native-nebula-ipv6-public-ingress-tuple-materialization";
  runtimeHosts = [
    "s-router-nixos"
    "s-router-clab"
    "s-router-test-clients"
  ];
  source = {
    kind = "intent-and-inventory-construction-candidate";
    sourcePath = "GAMP/SMT/FS-230-HDS-010-SDS-010-SMS-040/intent.nix";
    inventories = {
      clab = "GAMP/SMT/FS-230-HDS-010-SDS-010-SMS-040/inventory-clab.nix";
      nixos = "GAMP/SMT/FS-230-HDS-010-SDS-010-SMS-040/inventory-nixos.nix";
      testClients = "GAMP/SMT/FS-230-HDS-010-SDS-010-SMS-040/inventory-test-clients.nix";
    };
    evidenceBoundary = "construction-green-live-endpoint-policy-neutrality-pending";
  };
  status = "NOT OK";
  evidence = {
    command = "NETWORK_REPO_DIRECT_TEST_OK=1 tests/FS-230-HDS-010-SDS-010-SMS-040-native-protected-ipv6-ingress.sh";
    focusedTest = "network-control-plane-model/tests/FS-230-HDS-010-SDS-010-SMS-040-nebula-ipv6-public-ingress.sh; network-renderer-nixos/tests/FS-230-HDS-010-SDS-010-SMS-040-nebula-ipv6-public-ingress.sh; network-renderer-containerlab-linux-backend/tests/test-fs230-hds010-sds010-sms040-nebula-ipv6-public-ingress.sh";
    observedResult = "Retry-6 cold-staged exact pushed pins on all three isolated hosts and autonomously deployed both substrates. The allowed IPv6 UDP/4242 datagram crossed all five NixOS routers and reached the protected service endpoint, but the endpoint inherited a default-deny firewall and sent the datagram to nixos-fw-log-refuse. All denied-flow predicates passed. The row remains NOT OK until the endpoint renderer is policy-neutral, focused construction checks pass, and a new three-host cold stage proves the positive and negative matrix on both NixOS and CLAB without a hotpatch.";
  };
}
