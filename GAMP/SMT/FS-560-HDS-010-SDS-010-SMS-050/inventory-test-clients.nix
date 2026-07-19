{
  meta = {
    traceId = "FS-560-HDS-010-SDS-010-SMS-050";
    renderer = "test-clients";
    evidenceBoundary = "isolated-lab-only";
  };
  clients.lab-client = {
    interface = "tenant";
    identifiersToEnroll = [
      "mac"
      "stable-ipv6-iid"
      "duid"
      "iaid"
    ];
    assertions = {
      assignedIpv4Predictable = true;
      assignedIpv6Predictable = true;
      publishedAaaaPtr = true;
      unknownNamespaceNameTerminatesLocally = true;
      publicRecursionAuthorityUnchanged = true;
      protectedValuesRedacted = true;
    };
  };
}
