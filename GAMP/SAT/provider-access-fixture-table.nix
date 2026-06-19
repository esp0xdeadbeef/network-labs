let
  providerAccessRequiredFields = [
    [ "scenarioId" ]
    [ "gampId" ]
    [ "site" ]
    [ "provider" "role" ]
    [ "provider" "handoff" ]
    [ "provider" "addressDelivery" "ipv4" ]
    [ "provider" "addressDelivery" "ipv6" ]
    [ "provider" "addressDelivery" "excluded" ]
    [ "customer" "site" ]
    [ "customer" "coreNode" ]
    [ "customer" "coreInterface" ]
    [ "publicFacing" "ipv4" "sessionPrefix" ]
    [ "publicFacing" "ipv4" "providerAddress" ]
    [ "publicFacing" "ipv4" "customerAddress" ]
    [ "publicFacing" "ipv4" "snatPrivateTenants" ]
    [ "publicFacing" "ipv6" "delegatedAggregate" ]
    [ "publicFacing" "ipv6" "childPrefixLength" ]
    [ "publicFacing" "ipv6" "nat66" ]
    [ "firewall" "defaultInbound" ]
    [ "firewall" "allowEstablishedRelated" ]
    [ "firewall" "allowPppoeControl" ]
    [ "firewall" "publicIngress" ]
    [ "firewall" "leakPrevention" ]
    [ "dns" "followSource" ]
    [ "dns" "resolver" "consumer" ]
    [ "dns" "resolver" "implementationClass" ]
    [ "dns" "resolver" "upstreamSource" ]
    [ "failureExpectation" ]
    [ "probeIntent" ]
  ];
in
{
  attachments = {
    pppoeNixos = {
      scenarioId = "SAT-SCEN-PROVIDER-ATTACH-PPPOE-NIXOS-001";
      gampId = "FS-800-HDS-010-SDS-010-SMS-030";
      technology = "pppoe";
      sourceClass = "provider-access-realization-fact";
      realizationAuthority = "inventory";
      topologyAuthority = false;
      sideChannelAuthority = false;
      attachment = {
        kind = "access-space";
        site = "nixos";
        accessSpace = "client";
        method = "tenant-access";
        sourceNode = "nixos-router-access-client";
        runtimeNode = "esp-nixos-router-access-client";
        logicalInterface = "tenant-client";
      };
      realizationRef = {
        path = "controlPlane.providerAccess.scenarios.pppoeNixos";
        providerScenarioId = "SAT-SCEN-EMULATED-ISP-NIXOS-001";
      };
    };

    dhcpSlaacNixosClient = {
      scenarioId = "SAT-SCEN-PROVIDER-ATTACH-DHCP-SLAAC-NIXOS-001";
      gampId = "FS-800-HDS-010-SDS-010-SMS-030";
      technology = "dhcp-slaac";
      sourceClass = "provider-access-realization-fact";
      realizationAuthority = "inventory";
      topologyAuthority = false;
      sideChannelAuthority = false;
      attachment = {
        kind = "access-space";
        site = "nixos";
        accessSpace = "client";
        method = "tenant-access";
        sourceNode = "nixos-router-access-client";
        runtimeNode = "esp-nixos-router-access-client";
        logicalInterface = "tenant-client";
      };
      realizationRef = {
        path = "realization.nodes.esp-nixos-router-access-client.advertisements";
        advertisements = [
          "dhcp4"
          "dhcpv6"
          "ipv6Ra"
        ];
      };
    };

    nebulaNixosUnderlay = {
      scenarioId = "SAT-SCEN-PROVIDER-ATTACH-NEBULA-NIXOS-001";
      gampId = "FS-800-HDS-010-SDS-010-SMS-030";
      technology = "nebula";
      sourceClass = "provider-access-realization-fact";
      realizationAuthority = "inventory";
      topologyAuthority = false;
      sideChannelAuthority = false;
      attachment = {
        kind = "access-space";
        site = "nixos";
        accessSpace = "client";
        method = "tenant-access";
        sourceNode = "nixos-router-access-client";
        runtimeNode = "esp-nixos-router-core-nebula";
        logicalInterface = "tenant-client";
      };
      realizationRef = {
        path = "controlPlane.sites.esp.nixos.overlays.east-west";
        provider = "nebula";
        underlayAccess = {
          kind = "tenant";
          name = "client";
        };
      };
    };

    wireguardRemoteEgressHetz = {
      scenarioId = "SAT-SCEN-PROVIDER-ATTACH-WG-REMOTE-EGRESS-HETZ-001";
      gampId = "FS-800-HDS-010-SDS-010-SMS-030";
      technology = "wireguard-remote-egress";
      sourceClass = "provider-access-realization-fact";
      realizationAuthority = "inventory";
      topologyAuthority = false;
      sideChannelAuthority = false;
      attachment = {
        kind = "access-space";
        site = "hetz";
        accessSpace = "client";
        method = "tenant-access";
        sourceNode = "hetz-router-access-client";
        runtimeNode = "esp-hetz-router-nebula-core";
        logicalInterface = "tenant-client";
      };
      realizationRef = {
        path = "controlPlane.sites.esp.hetz.overlays.wg-routed64";
        provider = "wireguard";
        providerContract = "routed64";
      };
    };

    wireguardHost128Hetz = {
      scenarioId = "SAT-SCEN-PROVIDER-ATTACH-WG-HOST128-HETZ-001";
      gampId = "FS-800-HDS-010-SDS-010-SMS-030";
      technology = "wireguard-host-128";
      sourceClass = "provider-access-realization-fact";
      realizationAuthority = "inventory";
      topologyAuthority = false;
      sideChannelAuthority = false;
      attachment = {
        kind = "access-space";
        site = "hetz";
        accessSpace = "client";
        method = "tenant-access";
        sourceNode = "hetz-router-access-client";
        runtimeNode = "esp-hetz-router-nebula-core";
        logicalInterface = "tenant-client";
      };
      realizationRef = {
        path = "controlPlane.sites.esp.hetz.overlays.wg-host128-egress";
        provider = "wireguard";
        providerContract = "hostOnly128Egress";
      };
    };
  };

  pppoeNixos = {
    scenarioId = "SAT-SCEN-EMULATED-ISP-NIXOS-001";
    gampId = "FS-800-HDS-010-SDS-011-SMS-010";
    requiredFields = providerAccessRequiredFields;
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
    gampId = "FS-800-HDS-010-SDS-011-SMS-010";
    requiredFields = providerAccessRequiredFields;
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
