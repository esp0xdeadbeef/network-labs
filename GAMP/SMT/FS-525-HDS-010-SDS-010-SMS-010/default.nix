{
  layer = "SMT";
  traceId = "FS-525-HDS-010-SDS-010-SMS-010";
  canonicalSms = "network-codex-agent/GAMP/SMS/FS-525-HDS-010-SDS-010-SMS-010-named-core-resolver-binding.md";
  titleSlug = "named-core-resolver-binding";
  source = {
    kind = "canonical-sms-source-stub";
    sourcePath = "GAMP/SMT/FS-525-HDS-010-SDS-010-SMS-010/intent.nix";
    inventories = {
      clab = "GAMP/SMT/FS-525-HDS-010-SDS-010-SMS-010/inventory-clab.nix";
      nixos = "GAMP/SMT/FS-525-HDS-010-SDS-010-SMS-010/inventory-nixos.nix";
      testClients = "GAMP/SMT/FS-525-HDS-010-SDS-010-SMS-010/inventory-test-clients.nix";
    };
    evidenceBoundary = "source-stub-only";
  };
  validationContract = {
    substrates = [ "nixos" "clab" ];
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
    command = null;
    focusedTest = null;
    observedResult = "validation specification only; no focused construction or live test has executed this warning contract";
  };
}
