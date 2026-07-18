{
  layer = "SMT";
  traceId = "FS-270-HDS-010-SDS-010-SMS-020";
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-270-HDS-010-SDS-010-SMS-020-client-tenant-policy-transit.md";
  titleSlug = "client-tenant-policy-transit";
  source = {
    kind = "intent-source";
    sourcePath = "GAMP/SMT/FS-270-HDS-010-SDS-010-SMS-020/intent.nix";
    inventories = {
      nixos = "GAMP/SMT/FS-270-HDS-010-SDS-010-SMS-020/inventory-nixos.nix";
      clab = "GAMP/SMT/FS-270-HDS-010-SDS-010-SMS-020/inventory-clab.nix";
      testClients = "GAMP/SMT/FS-270-HDS-010-SDS-010-SMS-020/inventory-test-clients.nix";
      testClientIntent = "GAMP/SMT/FS-270-HDS-010-SDS-010-SMS-020/intent-test-clients.nix";
    };
    expectedRelationIds = [
      "FS-270-HDS-010-SDS-010-SMS-020__deny-reverse-new-flow"
      "FS-270-HDS-010-SDS-010-SMS-020__source-to-destination-icmp"
    ];
    evidenceBoundary = "isolated-dual-substrate-access-service-policy-state-owner";
  };
  status = "NOT OK";
  evidence = {
    command = "pending compiler-through-renderer predicate and cold-stage live verifier on s-router-nixos, s-router-clab, and s-router-test-clients";
    focusedTest = "tests/FS-270-HDS-010-SDS-010-SMS-020-access-service-policy-state-owner-source.sh";
    observedResult = "The isolated source is defined; pipeline ownership and cold-staged dual-stack stateful return remain to be validated.";
  };
}
