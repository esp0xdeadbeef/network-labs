{
  meta = {
    traceId = "FS-560-HDS-010-SDS-010-SMS-050";
    scope = "protected-reservation-name-live-probe";
  };

  deploymentHosts.s-router-test-clients = {
    bridgeNetworks.rsv560 = {
      mode = "vlan";
      parent = "eth0";
      vlan = 399;
    };
    bridgeNetworks.rsv560-clab = {
      mode = "vlan";
      parent = "eth0";
      vlan = 400;
    };
  };

  clients.lab-client = {
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
