{
  layer = "SMT";
  traceId = "FS-525-HDS-010-SDS-010-SMS-010";
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-525-HDS-010-SDS-010-SMS-010-named-core-resolver-binding.md";
  titleSlug = "named-core-resolver-binding";
  source = {
    kind = "intent-source";
    sourcePath = "GAMP/SMT/FS-525-HDS-010-SDS-010-SMS-010/intent.nix";
    expectedRelationIds = [
      "FS-525-HDS-010-SDS-010-SMS-010__client-to-access-dns"
      "FS-525-HDS-010-SDS-010-SMS-010__client-egress"
      "FS-525-HDS-010-SDS-010-SMS-010__access-dns-to-core-dns"
      "FS-525-HDS-010-SDS-010-SMS-010__core-dns-to-provider"
    ];
    inventories = {
      clab = "GAMP/SMT/FS-525-HDS-010-SDS-010-SMS-010/inventory-clab.nix";
      nixos = "GAMP/SMT/FS-525-HDS-010-SDS-010-SMS-010/inventory-nixos.nix";
      testClients = "GAMP/SMT/FS-525-HDS-010-SDS-010-SMS-010/inventory-test-clients.nix";
    };
    evidenceBoundary = "compiler-construction-only";
  };
  validationContract = {
    substrates = [
      "nixos"
      "clab"
    ];
    positive = {
      namedCoreBinding = true;
      topologyDerivedDualStackEndpoints = true;
      explicitMultiEgressSelection = true;
      expectedWarnings = [ ];
    };
    seededWarnings = {
      missingBinding = "DNS_CORE_BINDING_MISSING";
      literalBinding = "DNS_CORE_BINDING_LITERAL";
      invalidBinding = "DNS_CORE_BINDING_INVALID";
      ambiguousBinding = "DNS_CORE_BINDING_AMBIGUOUS";
      incompleteFamily = "DNS_CORE_FAMILY_INCOMPLETE";
      hardcodedCoreUpstream = "DNS_CORE_UPSTREAM_HARDCODED";
      substrateDivergence = "DNS_CORE_SUBSTRATE_DIVERGENCE";
    };
    warningPrivacy = {
      modeledIdsOnly = true;
      excludesAddresses = true;
      excludesProtectedIdentity = true;
      deterministicCandidateOrdering = true;
    };
  };
  status = "NOT OK";
  evidence = {
    command = "NETWORK_REPO_DIRECT_TEST_OK=1 NETWORK_LABS_PATH=/home/deadbeef/github/network-labs bash tests/FS-525-HDS-010-SDS-010-SMS-010-named-core-resolver-binding.sh";
    focusedTest = "network-compiler/tests/FS-525-HDS-010-SDS-010-SMS-010-named-core-resolver-binding.sh";
    observedResult = "compiler construction source implemented; downstream NFM, CPM, renderer equivalence, and cold-stage live validation remain NOT OK";
  };
}
