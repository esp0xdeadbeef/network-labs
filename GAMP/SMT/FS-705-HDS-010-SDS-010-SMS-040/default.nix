{
  layer = "SMT";
  traceId = "FS-705-HDS-010-SDS-010-SMS-040";
  evidenceBoundary = "construction-only";
  source = null;
  evidence = {
    owningRepo = "network-codex-agent";
    smtRow = "GAMP/SMT/README.md FS-705-HDS-010-SDS-010-SMS-040";
    status = "NOT OK";
    scope = "Access client endpoint coverage: SMT/SIT-only client endpoint coverage rule for selected access networks. Every selected access network with a client-capable IPv4 or IPv6 prefix materializes at least one s-router-test-clients endpoint, excluding VLAN11/VLAN12 fake upstream surfaces, IPv4 /31 and /32, and IPv6 /127 and /128. Six seeded negatives: missing IPv4 client, missing IPv6 client, fake upstream client, IPv4 p2p client, IPv6 p2p client, missing provenance.";
    sealedNegatives = [
      "diagnostic.validation-profile-access-client-missing"
      "diagnostic.validation-profile-access-client-missing"
      "diagnostic.validation-profile-access-client-not-eligible"
      "diagnostic.validation-profile-access-client-not-eligible"
      "diagnostic.validation-profile-access-client-not-eligible"
      "diagnostic.validation-profile-access-client-provenance-missing"
    ];
  };
}
