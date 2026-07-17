{
  meta = {
    traceId = "FS-970-HDS-010-SDS-020-SMS-040";
    scope = "protected-reservation-live-probe";
  };

  deploymentHosts.s-router-test-clients = {
    bridgeNetworks.rsv970 = {
      mode = "vlan";
      parent = "eth0";
      vlan = 397;
    };
  };
}
