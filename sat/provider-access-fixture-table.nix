{
  pppoeNixos = {
    scenarioId = "SAT-SCEN-EMULATED-ISP-NIXOS-001";
    gampId = "FS-800-HDS-010-SDS-010-SMS-010";
    site = "site-nixos";
    provider = {
      role = "emulated-isp";
      handoff = "pppoe";
      addressDelivery = {
        ipv4 = "pppoe-session-address";
        ipv6 = "pppoe-delegated-prefix";
        excluded = [
          "wan-dhcp"
          "wan-slaac"
        ];
      };
    };
    customer = {
      site = "nixos";
      coreNode = "nixos-router-core-isp-a";
      coreInterface = "pppoe-wan";
    };
    publicFacing = {
      ipv4 = {
        sessionPrefix = "203.0.113.8/30";
        providerAddress = "203.0.113.9";
        customerAddress = "203.0.113.10";
        snatPrivateTenants = true;
      };
      ipv6 = {
        delegatedAggregate = "2001:db8:800:10::/60";
        childPrefixLength = 64;
        nat66 = false;
      };
    };
    firewall = {
      defaultInbound = "deny";
      allowEstablishedRelated = true;
      allowPppoeControl = true;
      publicIngress = [ ];
      leakPrevention = [
        "deny-direct-public-dns-from-tenants"
        "deny-ula-to-emulated-isp"
        "deny-unmodeled-inbound-public"
      ];
    };
    dns = {
      followSource = true;
      resolver = {
        consumer = "site-resolver";
        implementationClass = "unbound-or-equivalent";
        upstreamSource = "follow-source";
      };
    };
    failureExpectation = "missing PPPoE session, public IPv4 session address, IPv6 delegated prefix, DNS behavior, firewall behavior, or translation behavior fails before SAT promotion";
    probeIntent = [
      "pppoe-session-up"
      "pppoe-ipv4-session-address"
      "pppoe-ipv6-delegated-prefix"
      "default-route-via-pppoe"
      "dns-follow-source"
      "nat44-private-egress"
      "no-wan-dhcp"
      "no-wan-slaac"
      "no-nat66-routed-gua"
    ];
  };

  pppoeClab = {
    scenarioId = "SAT-SCEN-EMULATED-ISP-CLAB-001";
    gampId = "FS-800-HDS-010-SDS-010-SMS-010";
    site = "site-clab";
    provider = {
      role = "emulated-isp";
      handoff = "pppoe";
      addressDelivery = {
        ipv4 = "pppoe-session-address";
        ipv6 = "pppoe-delegated-prefix";
        excluded = [
          "wan-dhcp"
          "wan-slaac"
        ];
      };
    };
    customer = {
      site = "clab";
      coreNode = "clab-router-core-simulated-isp";
      coreInterface = "pppoe-wan";
    };
    publicFacing = {
      ipv4 = {
        sessionPrefix = "203.0.113.12/30";
        providerAddress = "203.0.113.13";
        customerAddress = "203.0.113.14";
        snatPrivateTenants = true;
      };
      ipv6 = {
        delegatedAggregate = "2001:db8:800:20::/60";
        childPrefixLength = 64;
        nat66 = false;
      };
    };
    firewall = {
      defaultInbound = "deny";
      allowEstablishedRelated = true;
      allowPppoeControl = true;
      publicIngress = [ ];
      leakPrevention = [
        "deny-direct-public-dns-from-tenants"
        "deny-ula-to-emulated-isp"
        "deny-unmodeled-inbound-public"
      ];
    };
    dns = {
      followSource = true;
      resolver = {
        consumer = "site-resolver";
        implementationClass = "unbound-or-equivalent";
        upstreamSource = "follow-source";
      };
    };
    failureExpectation = "missing PPPoE session, public IPv4 session address, IPv6 delegated prefix, DNS behavior, firewall behavior, or translation behavior fails before SAT promotion";
    probeIntent = [
      "pppoe-session-up"
      "pppoe-ipv4-session-address"
      "pppoe-ipv6-delegated-prefix"
      "default-route-via-pppoe"
      "dns-follow-source"
      "nat44-private-egress"
      "no-wan-dhcp"
      "no-wan-slaac"
      "no-nat66-routed-gua"
    ];
  };
}
