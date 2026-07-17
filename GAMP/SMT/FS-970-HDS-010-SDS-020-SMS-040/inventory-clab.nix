{
  meta = {
    traceId = "FS-970-HDS-010-SDS-020-SMS-040";
    scope = "protected-reservation-live-probe-clab";
  };

  deploymentHosts.s-router-clab.bridgeNetworks.rsv970-clab = {
    mode = "vlan";
    parent = "eth0";
    vlan = 398;
  };

  realization.nodes."mini-smt-fs-970-hds-010-sds-020-sms-040-client-edge" = {
    host = "s-router-clab";
    logicalNode = {
      enterprise = "mini-smt";
      site = "FS-970-HDS-010-SDS-020-SMS-040";
      name = "client-edge";
    };
    platform = "nixos-container";
    ports.tenant-client = {
      logicalInterface = "tenant-client";
      attach = {
        kind = "bridge";
        bridge = "rsv970-clab";
      };
      interface.name = "tenant-client";
    };
    advertisements = {
      dhcp4.tenant-client = {
        dnsServers = [ "router-self" ];
        domain = "lan.";
        reservationSource = {
          schema = "gamp-protected-reservation-set-v1";
          sourceClass = "protected";
          sourceFile = "/run/secrets/fs970-clab-protected-reservations.json";
        };
      };
      dhcpv6.tenant-client = {
        dnsServers = [ "router-self" ];
        domain = "lan.";
        pool = {
          start = "fd42:03ca:50::100";
          end = "fd42:03ca:50::1ff";
        };
        reservationSource = {
          schema = "gamp-protected-reservation-set-v1";
          sourceClass = "protected";
          sourceFile = "/run/secrets/fs970-clab-protected-reservations.json";
        };
      };
      ipv6Ra.tenant-client = {
        dnssl = [ "lan." ];
        rdnss = [ "router-self" ];
        managed = true;
        otherConfig = true;
        onLink = true;
        autonomous = false;
      };
    };
    services.dns = { };
  };
}
