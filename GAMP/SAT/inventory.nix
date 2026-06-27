# SAT-SRC-INVENTORY-001: URS-190 / URS-190-FS-010. This is the controlled
# s-router SAT inventory source. It realizes the lab intent; examples under
# network-labs/examples are lower-layer fixtures only.
let
  intent = import ./intent.nix;
  providerAccessFixtureTable = import ./provider-access-fixture-table.nix;
  satSites = intent.esp;
  uniqueStrings = list: builtins.attrNames (builtins.listToAttrs (map (value: { name = value; value = true; }) list));
  stripCidr =
    value:
    let
      matched = builtins.match "([^/]+)(/.*)?" value;
    in
      if matched == null then value else builtins.elemAt matched 0;
  firstMatching =
    name: pred: list:
    let
      matches = builtins.filter pred list;
    in
      if matches == [ ] then throw "missing ${name} in SAT provider model source" else builtins.head matches;
  isIPv6 = value: builtins.match ".*:.*" value != null;
  siteTenantPrefixes =
    siteName: family:
    let
      prefixes = satSites.${siteName}.ownership.prefixes or [ ];
    in
      map (prefix: prefix.${family}) (builtins.filter (prefix: builtins.hasAttr family prefix) prefixes);
  satProviderNatSourceCidrs = {
    ipv4 = uniqueStrings (
      siteTenantPrefixes "nixos" "ipv4"
      ++ siteTenantPrefixes "clab" "ipv4"
      ++ siteTenantPrefixes "hetz" "ipv4"
    );
    ipv6 = uniqueStrings (
      siteTenantPrefixes "nixos" "ipv6"
      ++ siteTenantPrefixes "clab" "ipv6"
      ++ siteTenantPrefixes "hetz" "ipv6"
    );
  };
  satDeniedResolverCidrs = [
    "1.1.1.1/32"
    "2606:4700:4700::1111/128"
  ];
  withDeniedResolverCidrs = dns: dns // { deniedResolverCidrs = satDeniedResolverCidrs; };
  withDeniedResolverNode =
    node:
    node
    // {
      services = (node.services or { }) // {
        dns = withDeniedResolverCidrs (node.services.dns or { });
      };
    };
  satNixosPersistentStatePolicy = {
    persistence = {
      required = true;
      root = "/persist/s-router/state";
      durabilityClass = "restart-persistent";
      stateLossHandling = "fail-closed-require-persistent-state";
    };
    operationalRecords = {
      required = true;
      root = "/persist/s-router/records";
      durabilityClass = "restart-persistent";
      stateLossHandling = "fail-closed-require-persistent-state";
    };
  };
  satNixosRestartTolerantStatePolicy = {
    persistence = {
      required = false;
      root = "/run/s-router/state";
      durabilityClass = "restart-tolerant";
      stateLossHandling = "rebuild-from-modeled-runtime-facts";
    };
    operationalRecords = {
      required = false;
      root = "/run/s-router/records";
      durabilityClass = "restart-tolerant";
      stateLossHandling = "rebuild-from-modeled-runtime-facts";
    };
  };
  satClabRestartTolerantStatePolicy = {
    persistence = {
      required = false;
      root = "/run/s-router-clab/state";
      durabilityClass = "restart-tolerant";
      stateLossHandling = "rebuild-from-modeled-runtime-facts";
    };
    operationalRecords = {
      required = false;
      root = "/run/s-router-clab/records";
      durabilityClass = "restart-tolerant";
      stateLossHandling = "rebuild-from-modeled-runtime-facts";
    };
  };
  hasStatefulSurface = node: (node.advertisements or { }) != { } || (node.services or { }) != { };
  logicalNodeName = node: (node.logicalNode or { }).name or "";
  isNixosAccessNode = node: builtins.match "nixos-router-access-.*" (logicalNodeName node) != null;
  isNixosRestartTolerantNode = node: builtins.match "nixos-router-core-isp-.*" (logicalNodeName node) != null;
  withSatStatePolicy =
    nodes:
    builtins.mapAttrs
      (_: node:
        if hasStatefulSurface node && (node.host or null) == "s-router-test" && isNixosAccessNode node then
          node // { statePolicy = satNixosPersistentStatePolicy; }
        else if hasStatefulSurface node && (node.host or null) == "s-router-test" && isNixosRestartTolerantNode node then
          node // { statePolicy = satNixosRestartTolerantStatePolicy; }
        else if hasStatefulSurface node && (node.host or null) == "s-router-clab" then
          node // { statePolicy = satClabRestartTolerantStatePolicy; }
        else
          node)
      nodes;
  satEndpointAddresses = {
    clab-client01 = {
      ipv4 = [ "10.50.20.10" ];
      ipv6 = [ "fd42:dead:feed:20::10" ];
    };
    clab-client02 = {
      ipv4 = [ "10.50.20.11" ];
      ipv6 = [ "fd42:dead:feed:20::11" ];
    };
    clab-site-dns = {
      ipv4 = [ "10.50.10.1" ];
      ipv6 = [ "fd42:dead:feed:10::1" ];
    };
    clab-streaming01 = {
      ipv4 = [ "10.50.50.10" ];
      ipv6 = [ "fd42:dead:feed:50::10" ];
    };
    hetz-router-lighthouse = {
      ipv4 = [ "10.90.10.100" ];
      ipv6 = [ "fd42:dead:cafe:10::100" ];
    };
    hostile-node01 = {
      ipv4 = [ "10.70.10.10" ];
      ipv6 = [ "fd42:dead:feed:70::10" ];
    };
    nixos-hostile01 = {
      ipv4 = [ "10.20.70.10" ];
      ipv6 = [ "fd42:dead:beef:70::10" ];
    };
    nebula01 = {
      ipv4 = [ "10.20.30.10" ];
      ipv6 = [ "fd42:dead:beef:30::10" ];
    };
    streaming01 = {
      ipv4 = [ "10.20.50.10" ];
      ipv6 = [ "fd42:dead:beef:50::10" ];
    };
    site-dns-mgmt = {
      ipv4 = [ "10.20.10.1" ];
      ipv6 = [ "fd42:dead:beef:10::1" ];
    };
    hetz-dns-dmz = {
      ipv4 = [ "10.90.10.1" ];
      ipv6 = [ "fd42:dead:cafe:10::1" ];
    };
    hetz-client01 = {
      ipv4 = [ "10.90.20.10" ];
      ipv6 = [ "fd42:dead:cafe:20::10" ];
    };
  };
  endpointAddress = endpoint: family: builtins.head satEndpointAddresses.${endpoint}.${family};

  clabAccessTenants = {
    admin = { };
    client = { };
    dmz = { };
    hostile = { };
    mgmt = { };
    streaming = { };
  };

  clabAccessNode = tenant: spec: {
    advertisements = {
      dhcp4."tenant-${tenant}" = {
        dnsServers = [ "router-self" ];
        domain = "lan.";
      };
      ipv6Ra."tenant-${tenant}" = {
        dnssl = [ "lan." ];
        rdnss = [ "router-self" ];
      };
    };
    host = "s-router-clab";
    logicalNode = {
      enterprise = "esp";
      name = "clab-router-access-${tenant}";
      site = "clab";
    };
    platform = "nixos-container";
    ports = {
      "tenant-${tenant}" = {
        attach = {
          bridge = tenant;
          kind = "bridge";
        };
        interface = {
          name = clabAccessIfName tenant;
        };
        logicalInterface = "tenant-${tenant}";
      };
      transit-downstream = {
        adapterName = "p2p-clab-router-access-${tenant}-clab-router-downstream-transit-downstream";
        attach = {
          bridge = "br-clab-downstream-${tenant}";
          kind = "bridge";
        };
        interface = {
          name = "transit";
        };
        link = "p2p-clab-router-access-${tenant}-clab-router-downstream";
      };
    };
    services = {
      dns = withDeniedResolverCidrs {
        advertised = {
          dnsServers = [ "router-self" ];
          rdnss = [ "router-self" ];
        };
      };
    };
  };

  clabAccessNodes = builtins.listToAttrs (
    map (tenant: {
      name = "esp-clab-router-access-${tenant}";
      value = clabAccessNode tenant clabAccessTenants.${tenant};
    }) (builtins.attrNames clabAccessTenants)
  );

  clabAccessTenantNames = builtins.attrNames clabAccessTenants;
  clabRuntimeTenantName = tenant: if tenant == "streaming" then "stream" else tenant;
  clabAccessIfName = tenant: "tenant-${clabRuntimeTenantName tenant}";
  clabDownstreamAccessIfName = tenant: "access-${clabRuntimeTenantName tenant}";
  clabDownstreamPolicyIfName = tenant: "policy-${clabRuntimeTenantName tenant}";
  clabPolicyDownstreamIfName = tenant: "down-${clabRuntimeTenantName tenant}";
  clabPolicyWanIfName = tenant: "up-${clabRuntimeTenantName tenant}";
  clabUpstreamWanIfName = tenant: "pol-${clabRuntimeTenantName tenant}";
  clabWanTenants = [
    "admin"
    "client"
    "mgmt"
    "streaming"
  ];
  clabEastWestTenants = [ "hostile" ];

  # SAT-SRC-INVENTORY-WIREGUARD-PROVIDER-CONTRACTS: controlled WireGuard
  # provider contracts for host-only /128 egress, provider-owned /64 routing,
  # and public-ingress/port-forward SAT source coverage.
  wireguardProviderContracts = {
    hostOnly128Egress = rec {
      id = "sat-wg-host128-egress";
      provider = {
        class = "self-hosted";
        mode = "egress-only";
        prefixAuthority = "host-only-128";
        publicEndpoint = {
          address = "198.51.100.128";
          port = 51820;
          transport = "udp";
        };
      };
      interfaces = {
        wan = "wan";
        lan = "wg128-lan";
        vpn = "wg128";
      };
      profile = {
        mode = "generated-peer";
        generatedPeer = {
          privateKeyFile = "/run/secrets/wireguard-sat-host128-private-key";
          addresses = [
            "10.66.128.2/32"
            "2001:db8:128::2/128"
          ];
          dns = [ "10.66.128.1" ];
          mtu = 1420;
          peers = [
            {
              publicKey = "bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb=";
              endpoint = "198.51.100.128:51820";
              allowedIPs = [
                "0.0.0.0/0"
                "::/0"
              ];
              presharedKeyFile = "/run/secrets/wireguard-sat-host128-psk";
              persistentKeepalive = 25;
            }
          ];
        };
      };
      dns.mode = "segmented-provider-bootstrap";
      runtime = {
        generatedConfigPath = "/run/network-renderer-wireguard/sat-wg-host128.conf";
        uuidFile = "/run/network-renderer-wireguard/sat-wg-host128.uuid";
      };
      publicIngress = [ ];
      portForwards = [ ];
      lan = {
        ipv4.address = "10.66.128.1/24";
        ipv6.address = "fd42:dead:ff80:128::1/64";
      };
      nat = {
        ipv4 = {
          enable = true;
          sourceCidrs = satProviderNatSourceCidrs.ipv4;
          toAddress = provider.publicEndpoint.address;
        };
        ipv6 = {
          enable = true;
          sourceCidrs = satProviderNatSourceCidrs.ipv6;
          toAddress = stripCidr (firstMatching "host-only /128 generated IPv6 address" isIPv6 profile.generatedPeer.addresses);
        };
      };
      services = {
        dhcp4 = {
          enable = true;
          subnet = "10.66.128.0/24";
          pool = "10.66.128.100 - 10.66.128.200";
          gateway = "10.66.128.1";
          dns = [ "10.66.128.1" ];
        };
        ra = {
          enable = true;
          prefix = "fd42:dead:ff80:128::/64";
          rdnss = [ "fd42:dead:ff80:128::1" ];
        };
        healthCheck.enable = true;
      };
    };

    routed64 = rec {
      id = "sat-wg-routed64";
      provider = {
        class = "self-hosted";
        mode = "public-ingress";
        prefixAuthority = "provider-owned-prefix";
        publicEndpoint = {
          address = "198.51.100.64";
          port = 51821;
          transport = "udp";
        };
      };
      interfaces = {
        wan = "wan";
        lan = "wg64-lan";
        vpn = "wg64";
      };
      profile = {
        mode = "generated-peer";
        generatedPeer = {
          privateKeyFile = "/run/secrets/wireguard-sat-routed64-private-key";
          addresses = [
            "10.66.64.2/32"
            "2001:db8:64::2/128"
          ];
          dns = [ "10.66.64.1" ];
          mtu = 1420;
          peers = [
            {
              publicKey = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa=";
              endpoint = "198.51.100.64:51821";
              allowedIPs = [
                "0.0.0.0/0"
                "::/0"
              ];
              presharedKeyFile = "/run/secrets/wireguard-sat-routed64-psk";
              persistentKeepalive = 25;
            }
          ];
        };
      };
      dns.mode = "segmented-provider-bootstrap";
      runtime = {
        generatedConfigPath = "/run/network-renderer-wireguard/sat-wg-routed64.conf";
        uuidFile = "/run/network-renderer-wireguard/sat-wg-routed64.uuid";
      };
      publicIngress = [
        {
          id = "sat-wg-public-tcp-8447";
          protocol = "tcp";
          listenPort = 8447;
          ingressInterface = "wg64";
          targetAddress = endpointAddress "hetz-client01" "ipv4";
          targetPort = 4446;
          targetInterface = "wg64-lan";
        }
      ];
      portForwards = [
        {
          id = "sat-wg-public-udp-51821";
          protocol = "udp";
          listenPort = 51822;
          ingressInterface = "wg64";
          targetAddress = endpointAddress "hetz-client01" "ipv4";
          targetPort = 4446;
          targetInterface = "wg64-lan";
        }
      ];
      lan = {
        ipv4.address = "10.66.64.1/24";
        ipv6.address = "fd42:dead:ff80:64::1/64";
      };
      routes = {
        ipv6.providerOwnedPrefixes = [ "2001:db8:64:100::/64" ];
        returnRoutes = [
          {
            destination = "2001:db8:64:100::/64";
            gateway = "fd42:dead:ff80:64::2";
            interface = "wg64-lan";
          }
        ];
      };
      nat = {
        ipv4 = {
          enable = true;
          sourceCidrs = [ "10.66.64.0/24" ];
        };
        ipv6 = {
          enable = false;
          sourceCidrs = [ ];
        };
      };
      services = {
        dhcp4 = {
          enable = true;
          subnet = "10.66.64.0/24";
          pool = "10.66.64.100 - 10.66.64.200";
          gateway = "10.66.64.1";
          dns = [ "10.66.64.1" ];
        };
        ra = {
          enable = true;
          prefix = "2001:db8:64:100::/64";
          rdnss = [ "fd42:dead:ff80:64::1" ];
        };
        healthCheck.enable = true;
      };
    };
  };

  pppoeRuntimeContracts = {
    pppoeNixos = {
      providerRuntimeNode = "esp-nixos-router-upstream";
      providerLogicalNode = "nixos-router-upstream";
      customerRuntimeNode = "esp-nixos-router-core-isp-a";
      handoff = {
        bridge = "br-nix-pppoe";
        link = "sat-pppoe-nixos-handoff";
        providerPort = "pppoe-server";
        providerInterface = "pppoe-server";
        customerPort = "pppoe-wan";
        customerInterface = "pppoe-wan";
      };
      servicePlacement = {
        server = {
          node = "esp-nixos-router-upstream";
          service = "pppoe.server";
          interface = "pppoe-server";
        };
        client = {
          node = "esp-nixos-router-core-isp-a";
          service = "pppoe.client";
          interface = "pppoe-wan";
          runtimeInterface = "ppp0";
          defaultRoute = true;
          usePeerDns = true;
        };
      };
    };

    pppoeClab = {
      providerRuntimeNode = "esp-clab-router-upstream";
      providerLogicalNode = "clab-router-upstream";
      customerRuntimeNode = "esp-clab-router-core-simulated-isp";
      handoff = {
        bridge = "br-clab-pppoe";
        link = "sat-pppoe-clab-handoff";
        providerPort = "pppoe-server";
        providerInterface = "pppoe-server";
        customerPort = "pppoe-wan";
        customerInterface = "pppoe-wan";
      };
      servicePlacement = {
        server = {
          node = "esp-clab-router-upstream";
          service = "pppoe.server";
          interface = "pppoe-server";
        };
        client = {
          node = "esp-clab-router-core-simulated-isp";
          service = "pppoe.client";
          interface = "pppoe-wan";
          runtimeInterface = "ppp0";
          defaultRoute = true;
          usePeerDns = true;
        };
      };
    };
  };

  # SAT-SRC-INVENTORY-UPSTREAM-EMULATION: realization bindings for the
  # emulated-ISP scenarios declared in the provider-access fixture table.
  # These rows bind backend, host, handoff substrate, AC implementation, and
  # lab-only credential references for the owning harnesses.
  providerAccessRealization = {
    pppoeNixos = {
      scenarioId = providerAccessFixtureTable.pppoeNixos.scenarioId;
      gampId = providerAccessFixtureTable.pppoeNixos.gampId;
      backend = "nixos";
      site = "nixos";
      host = "s-router-nixos";
      fixtureRef = {
        marker = "SAT-SRC-INVENTORY-UPSTREAM-EMULATION";
        customerCoreNode = providerAccessFixtureTable.pppoeNixos.customer.coreNode;
        customerCoreInterface = providerAccessFixtureTable.pppoeNixos.customer.coreInterface;
      };
      substrate = {
        labUplink = {
          name = "uplink-isp-a";
          bridge = "br-uplink0";
          vlan = 4;
        };
        ispHandoff = {
          kind = "isolated-bridge";
          bridge = "br-nix-pppoe";
          physical = false;
        };
        mtu = 1492;
      };
      accessConcentrator = {
        implementation = "accel-ppp";
        node = pppoeRuntimeContracts.pppoeNixos.providerRuntimeNode;
        side = "provider";
      };
      runtime = pppoeRuntimeContracts.pppoeNixos;
      credentials = {
        labOnly = true;
        usernameFile = "/run/secrets/sat-pppoe-nixos-username";
        passwordFile = "/run/secrets/sat-pppoe-nixos-password";
      };
    };

    pppoeClab = {
      scenarioId = providerAccessFixtureTable.pppoeClab.scenarioId;
      gampId = providerAccessFixtureTable.pppoeClab.gampId;
      backend = "clab";
      site = "clab";
      host = "s-router-clab";
      fixtureRef = {
        marker = "SAT-SRC-INVENTORY-UPSTREAM-EMULATION";
        customerCoreNode = providerAccessFixtureTable.pppoeClab.customer.coreNode;
        customerCoreInterface = providerAccessFixtureTable.pppoeClab.customer.coreInterface;
      };
      substrate = {
        labUplink = {
          name = "uplink-isp-a";
          bridge = "br-uplink0";
          vlan = 4;
        };
        ispHandoff = {
          kind = "isolated-bridge";
          bridge = "br-clab-pppoe";
          physical = false;
        };
        mtu = 1492;
      };
      accessConcentrator = {
        implementation = "accel-ppp";
        node = pppoeRuntimeContracts.pppoeClab.providerRuntimeNode;
        side = "provider";
      };
      runtime = pppoeRuntimeContracts.pppoeClab;
      credentials = {
        labOnly = true;
        usernameFile = "/run/secrets/sat-pppoe-clab-username";
        passwordFile = "/run/secrets/sat-pppoe-clab-password";
      };
    };
  };

  # SAT-SRC-INVENTORY-PROVIDER-ACCESS-ATTACHMENTS: attachment records for
  # provider and overlay realization technologies. These are ordinary
  # access-space realization facts, not topology classes or side-channel policy
  # authority.
  providerAccessAttachmentRealization = providerAccessFixtureTable.attachments;

  clabDownstreamAccessPorts = builtins.listToAttrs (
    map (tenant: {
      name = "access-${tenant}";
      value = {
        adapterName = "p2p-clab-router-access-${tenant}-clab-router-downstream-access-${tenant}";
        attach = {
          bridge = "br-clab-downstream-${tenant}";
          kind = "bridge";
        };
        interface = {
          name = clabDownstreamAccessIfName tenant;
        };
        link = "p2p-clab-router-access-${tenant}-clab-router-downstream";
      };
    }) clabAccessTenantNames
  );

  clabDownstreamPolicyPorts = builtins.listToAttrs (
    map (tenant: {
      name = "policy-${tenant}";
      value = {
        adapterName = "p2p-clab-router-downstream-clab-router-policy--access-clab-router-access-${tenant}-policy-${tenant}";
        attach = {
          bridge = "br-clab-downstream-policy-access-${tenant}";
          kind = "bridge";
        };
        interface = {
          name = clabDownstreamPolicyIfName tenant;
        };
        link = "p2p-clab-router-downstream-clab-router-policy--access-clab-router-access-${tenant}";
      };
    }) clabAccessTenantNames
  );

  clabPolicyDownstreamPorts = builtins.listToAttrs (
    map (tenant: {
      name = "downstream-${tenant}";
      value = {
        adapterName = "p2p-clab-router-downstream-clab-router-policy--access-clab-router-access-${tenant}-downstream-${tenant}";
        attach = {
          bridge = "br-clab-downstream-policy-access-${tenant}";
          kind = "bridge";
        };
        interface = {
          name = clabPolicyDownstreamIfName tenant;
        };
        link = "p2p-clab-router-downstream-clab-router-policy--access-clab-router-access-${tenant}";
      };
    }) clabAccessTenantNames
  );

  clabPolicyWanPorts = builtins.listToAttrs (
    map (tenant: {
      name = "upstream-${tenant}";
      value = {
        adapterName = "p2p-clab-router-policy-clab-router-upstream--access-clab-router-access-${tenant}--uplink-wan-upstream-${tenant}";
        attach = {
          bridge = "br-clab-policy-upstream-access-${tenant}";
          kind = "bridge";
        };
        interface = {
          name = clabPolicyWanIfName tenant;
        };
        link = "p2p-clab-router-policy-clab-router-upstream--access-clab-router-access-${tenant}--uplink-wan";
      };
    }) clabWanTenants
  );

  clabPolicyEastWestPorts = builtins.listToAttrs (
    map (tenant: {
      name = "upstream-${tenant}-east-west";
      value = {
        adapterName = "p2p-clab-router-policy-clab-router-upstream--access-clab-router-access-${tenant}--uplink-east-west-upstream-${tenant}-east-west";
        attach = {
          bridge = "br-clab-policy-upstream-access-${tenant}-east-west";
          kind = "bridge";
        };
        interface = {
          name = "up-${tenant}-ew";
        };
        link = "p2p-clab-router-policy-clab-router-upstream--access-clab-router-access-${tenant}--uplink-east-west";
      };
    }) clabEastWestTenants
  );

  clabUpstreamWanPorts = builtins.listToAttrs (
    map (tenant: {
      name = "policy-${tenant}";
      value = {
        adapterName = "p2p-clab-router-policy-clab-router-upstream--access-clab-router-access-${tenant}--uplink-wan-policy-${tenant}";
        attach = {
          bridge = "br-clab-policy-upstream-access-${tenant}";
          kind = "bridge";
        };
        interface = {
          name = clabUpstreamWanIfName tenant;
        };
        link = "p2p-clab-router-policy-clab-router-upstream--access-clab-router-access-${tenant}--uplink-wan";
      };
    }) clabWanTenants
  );

  clabUpstreamEastWestPorts = builtins.listToAttrs (
    map (tenant: {
      name = "policy-${tenant}-east-west";
      value = {
        adapterName = "p2p-clab-router-policy-clab-router-upstream--access-clab-router-access-${tenant}--uplink-east-west-policy-${tenant}-east-west";
        attach = {
          bridge = "br-clab-policy-upstream-access-${tenant}-east-west";
          kind = "bridge";
        };
        interface = {
          name = "pol-${tenant}-ew";
        };
        link = "p2p-clab-router-policy-clab-router-upstream--access-clab-router-access-${tenant}--uplink-east-west";
      };
    }) clabEastWestTenants
  );

  secretPolicyNeutral = {
    createsRouteAuthority = false;
    createsFirewallPolicy = false;
    createsDnsPolicy = false;
    createsPublicIngress = false;
    createsTenantReachability = false;
    createsTrustBoundary = false;
    createsNetworkBehavior = false;
  };

  satSecretSourceSpecs = [
    {
      id = "sat-secret-pppoe-nixos-username";
      credentialClass = "provider-credential";
      site = "nixos";
      tenant = null;
      host = "s-router-nixos";
      consumer = {
        kind = "service";
        node = "esp-nixos-router-core-isp-a";
        name = "pppoe.client";
      };
      purpose = "pppoe-username";
      lifecycle = "lab-runtime";
      required = true;
      sourceClass = "deployment-platform-secret-reference";
      sourceName = "sat-pppoe-nixos-username";
      runtimePath = "sat-pppoe-nixos-username";
      sourceFieldPath = "controlPlane.providerAccess.scenarios.pppoeNixos.credentials.usernameFile";
    }
    {
      id = "sat-secret-pppoe-nixos-password";
      credentialClass = "provider-credential";
      site = "nixos";
      tenant = null;
      host = "s-router-nixos";
      consumer = {
        kind = "service";
        node = "esp-nixos-router-core-isp-a";
        name = "pppoe.client";
      };
      purpose = "pppoe-password";
      lifecycle = "lab-runtime";
      required = true;
      sourceClass = "deployment-platform-secret-reference";
      sourceName = "sat-pppoe-nixos-password";
      runtimePath = "sat-pppoe-nixos-password";
      sourceFieldPath = "controlPlane.providerAccess.scenarios.pppoeNixos.credentials.passwordFile";
    }
    {
      id = "sat-secret-pppoe-clab-username";
      credentialClass = "provider-credential";
      site = "clab";
      tenant = null;
      host = "s-router-clab";
      consumer = {
        kind = "service";
        node = "esp-clab-router-core-simulated-isp";
        name = "pppoe.client";
      };
      purpose = "pppoe-username";
      lifecycle = "lab-runtime";
      required = true;
      sourceClass = "deployment-platform-secret-reference";
      sourceName = "sat-pppoe-clab-username";
      runtimePath = "sat-pppoe-clab-username";
      sourceFieldPath = "controlPlane.providerAccess.scenarios.pppoeClab.credentials.usernameFile";
    }
    {
      id = "sat-secret-pppoe-clab-password";
      credentialClass = "provider-credential";
      site = "clab";
      tenant = null;
      host = "s-router-clab";
      consumer = {
        kind = "service";
        node = "esp-clab-router-core-simulated-isp";
        name = "pppoe.client";
      };
      purpose = "pppoe-password";
      lifecycle = "lab-runtime";
      required = true;
      sourceClass = "deployment-platform-secret-reference";
      sourceName = "sat-pppoe-clab-password";
      runtimePath = "sat-pppoe-clab-password";
      sourceFieldPath = "controlPlane.providerAccess.scenarios.pppoeClab.credentials.passwordFile";
    }
    {
      id = "sat-secret-wireguard-host128-private-key";
      credentialClass = "wireguard-credential";
      site = "hetz";
      tenant = "dmz";
      host = "s-router-hetzner-anywhere";
      consumer = {
        kind = "provider-contract";
        node = "hetz-router-nebula-core";
        name = "wireguard.hostOnly128Egress";
      };
      purpose = "wireguard-private-key";
      lifecycle = "deployment-runtime";
      required = true;
      sourceClass = "deployment-platform-secret-reference";
      sourceName = "wireguard-sat-host128-private-key";
      runtimePath = "wireguard-sat-host128-private-key";
      sourceFieldPath = "controlPlane.sites.esp.hetz.overlays.wg-host128-egress.wireguard.providerContract.profile.generatedPeer.privateKeyFile";
    }
    {
      id = "sat-secret-wireguard-host128-psk";
      credentialClass = "wireguard-credential";
      site = "hetz";
      tenant = "dmz";
      host = "s-router-hetzner-anywhere";
      consumer = {
        kind = "provider-contract";
        node = "hetz-router-nebula-core";
        name = "wireguard.hostOnly128Egress";
      };
      purpose = "wireguard-preshared-key";
      lifecycle = "deployment-runtime";
      required = true;
      sourceClass = "deployment-platform-secret-reference";
      sourceName = "wireguard-sat-host128-psk";
      runtimePath = "wireguard-sat-host128-psk";
      sourceFieldPath = "controlPlane.sites.esp.hetz.overlays.wg-host128-egress.wireguard.providerContract.profile.generatedPeer.peers[0].presharedKeyFile";
    }
    {
      id = "sat-secret-wireguard-routed64-private-key";
      credentialClass = "wireguard-credential";
      site = "hetz";
      tenant = "dmz";
      host = "s-router-hetzner-anywhere";
      consumer = {
        kind = "provider-contract";
        node = "hetz-router-nebula-core";
        name = "wireguard.routed64";
      };
      purpose = "wireguard-private-key";
      lifecycle = "deployment-runtime";
      required = true;
      sourceClass = "deployment-platform-secret-reference";
      sourceName = "wireguard-sat-routed64-private-key";
      runtimePath = "wireguard-sat-routed64-private-key";
      sourceFieldPath = "controlPlane.sites.esp.hetz.overlays.wg-routed64.wireguard.providerContract.profile.generatedPeer.privateKeyFile";
    }
    {
      id = "sat-secret-wireguard-routed64-psk";
      credentialClass = "wireguard-credential";
      site = "hetz";
      tenant = "dmz";
      host = "s-router-hetzner-anywhere";
      consumer = {
        kind = "provider-contract";
        node = "hetz-router-nebula-core";
        name = "wireguard.routed64";
      };
      purpose = "wireguard-preshared-key";
      lifecycle = "deployment-runtime";
      required = true;
      sourceClass = "deployment-platform-secret-reference";
      sourceName = "wireguard-sat-routed64-psk";
      runtimePath = "wireguard-sat-routed64-psk";
      sourceFieldPath = "controlPlane.sites.esp.hetz.overlays.wg-routed64.wireguard.providerContract.profile.generatedPeer.peers[0].presharedKeyFile";
    }
    {
      id = "sat-secret-hetzner-public-ipv4";
      credentialClass = "deployment-runtime-fact";
      site = "hetz";
      tenant = "dmz";
      host = "s-router-hetzner-anywhere";
      consumer = {
        kind = "runtime-fact";
        node = "hetz-router-nebula-core";
        name = "public-endpoint-ipv4";
      };
      purpose = "public-endpoint-ipv4";
      lifecycle = "deployment-runtime";
      required = true;
      sourceClass = "runtime-fact";
      sourceName = "hetzner-public-ipv4";
      runtimePath = "hetzner-public-ipv4";
      sourceFieldPath = "runtime.publicEndpoint.ipv4Secret";
    }
    {
      id = "sat-secret-hetzner-public-ipv6";
      credentialClass = "deployment-runtime-fact";
      site = "hetz";
      tenant = "dmz";
      host = "s-router-hetzner-anywhere";
      consumer = {
        kind = "runtime-fact";
        node = "hetz-router-nebula-core";
        name = "public-endpoint-ipv6";
      };
      purpose = "public-endpoint-ipv6";
      lifecycle = "deployment-runtime";
      required = true;
      sourceClass = "runtime-fact";
      sourceName = "hetzner-public-ipv6";
      runtimePath = "hetzner-public-ipv6";
      sourceFieldPath = "runtime.publicEndpoint.ipv6Secret";
    }
    {
      id = "sat-secret-hetzner-lighthouse-public-ipv4";
      credentialClass = "overlay-runtime-fact";
      site = "hetz";
      tenant = "dmz";
      host = "s-router-hetzner-anywhere";
      consumer = {
        kind = "overlay";
        node = "hetz-router-lighthouse";
        name = "nebula-lighthouse-endpoint";
      };
      purpose = "nebula-lighthouse-endpoint-ipv4";
      lifecycle = "deployment-runtime";
      required = true;
      sourceClass = "runtime-fact";
      sourceName = "hetzner-lighthouse-public-ipv4";
      runtimePath = "hetzner-lighthouse-public-ipv4";
      sourceFieldPath = "runtime.publicEndpoint.lighthouseIpv4Secret";
    }
    {
      id = "sat-secret-hetzner-primary-interface-mac";
      credentialClass = "deployment-runtime-fact";
      site = "hetz";
      tenant = null;
      host = "s-router-hetzner-anywhere";
      consumer = {
        kind = "runtime-fact";
        node = "hetz-router-nebula-core";
        name = "primary-interface-mac";
      };
      purpose = "deployment-interface-identity";
      lifecycle = "deployment-runtime";
      required = true;
      sourceClass = "protected-inventory";
      sourceName = "hetzner-primary-interface-mac";
      runtimePath = "hetzner-primary-interface-mac";
      sourceFieldPath = "runtime.publicEndpoint.macSecret";
    }
    {
      id = "sat-secret-nebula-lighthouse-ipv4";
      credentialClass = "overlay-runtime-fact";
      site = "hetz";
      tenant = "dmz";
      host = "s-router-hetzner-anywhere";
      consumer = {
        kind = "overlay";
        node = "hetz-router-lighthouse";
        name = "nebula-overlay-client-ipv4";
      };
      purpose = "nebula-overlay-client-address-ipv4";
      lifecycle = "deployment-runtime";
      required = true;
      sourceClass = "runtime-fact";
      sourceName = "nebula-hetzner-lighthouse-ipv4";
      runtimePath = "nebula-hetzner-lighthouse-ipv4";
      sourceFieldPath = "runtime.overlayClients.hetznerLighthouse.addr4Secret";
    }
    {
      id = "sat-secret-nebula-lighthouse-ipv6";
      credentialClass = "overlay-runtime-fact";
      site = "hetz";
      tenant = "dmz";
      host = "s-router-hetzner-anywhere";
      consumer = {
        kind = "overlay";
        node = "hetz-router-lighthouse";
        name = "nebula-overlay-client-ipv6";
      };
      purpose = "nebula-overlay-client-address-ipv6";
      lifecycle = "deployment-runtime";
      required = true;
      sourceClass = "runtime-fact";
      sourceName = "nebula-hetzner-lighthouse-ipv6";
      runtimePath = "nebula-hetzner-lighthouse-ipv6";
      sourceFieldPath = "runtime.overlayClients.hetznerLighthouse.addr6Secret";
    }
    {
      id = "sat-secret-nixos-hostile-public-prefix";
      credentialClass = "deployment-runtime-fact";
      site = "nixos";
      tenant = "hostile";
      host = "s-router-nixos";
      consumer = {
        kind = "tenant-runtime-prefix";
        node = "esp-nixos-router-access-hostile";
        name = "hostile-public";
      };
      purpose = "tenant-routed-prefix";
      lifecycle = "deployment-runtime";
      required = true;
      sourceClass = "runtime-fact";
      sourceName = "access-node-ipv6-prefix-esp-nixos-router-access-hostile";
      runtimePath = "access-node-ipv6-prefix-esp-nixos-router-access-hostile";
      sourceFieldPath = "intent.esp.nixos.ownership.prefixes.hostile-public.sourceFile";
    }
    {
      id = "sat-secret-clab-client-public-prefix";
      credentialClass = "deployment-runtime-fact";
      site = "clab";
      tenant = "client";
      host = "s-router-clab";
      consumer = {
        kind = "tenant-runtime-prefix";
        node = "esp-clab-router-access-client";
        name = "clab-client-public";
      };
      purpose = "tenant-routed-prefix";
      lifecycle = "deployment-runtime";
      required = true;
      sourceClass = "runtime-fact";
      sourceName = "access-node-ipv6-prefix-esp-clab-router-access-client";
      runtimePath = "access-node-ipv6-prefix-esp-clab-router-access-client";
      sourceFieldPath = "controlPlane.sites.esp.clab.tenants.client.routedPrefixes.clab-client-public.sourceFile";
    }
    {
      id = "sat-secret-clab-hostile-public-prefix";
      credentialClass = "deployment-runtime-fact";
      site = "clab";
      tenant = "hostile";
      host = "s-router-clab";
      consumer = {
        kind = "tenant-runtime-prefix";
        node = "esp-clab-router-access-hostile";
        name = "hostile-public";
      };
      purpose = "tenant-routed-prefix";
      lifecycle = "deployment-runtime";
      required = true;
      sourceClass = "runtime-fact";
      sourceName = "access-node-ipv6-prefix-esp-clab-router-access-hostile";
      runtimePath = "access-node-ipv6-prefix-esp-clab-router-access-hostile";
      sourceFieldPath = "controlPlane.sites.esp.clab.tenants.hostile.routedPrefixes.hostile-public.sourceFile";
    }
    {
      id = "sat-secret-hetz-client-public-prefix";
      credentialClass = "deployment-runtime-fact";
      site = "hetz";
      tenant = "client";
      host = "s-router-hetzner-anywhere";
      consumer = {
        kind = "tenant-runtime-prefix";
        node = "esp-hetz-router-access-client";
        name = "hetz-client-public";
      };
      purpose = "tenant-routed-prefix";
      lifecycle = "deployment-runtime";
      required = true;
      sourceClass = "runtime-fact";
      sourceName = "access-node-ipv6-prefix-esp-hetz-router-access-client";
      runtimePath = "access-node-ipv6-prefix-esp-hetz-router-access-client";
      sourceFieldPath = "controlPlane.sites.esp.hetz.tenants.client.routedPrefixes.hetz-client-public.sourceFile";
    }
  ];

  satSecretDeclarations = map (spec: {
    inherit (spec) id credentialClass site tenant host consumer purpose lifecycle;
    required = spec.required;
    requiredness = if spec.required then "mandatory" else "optional";
    material = "reference-only";
    plaintextMaterial = false;
    sourceSelected = true;
    policyAuthority = secretPolicyNeutral;
    gampIds = [
      "FS-810-HDS-010-SDS-010-SMS-010"
      "FS-810-HDS-010-SDS-010-SMS-020"
      "FS-810-HDS-010-SDS-010-SMS-030"
    ];
  }) satSecretSourceSpecs;

  satSecretSources = map (spec: {
    id = "${spec.id}-source";
    declarationId = spec.id;
    sourceClass = spec.sourceClass;
    reference = {
      name = spec.sourceName;
      runtimePath = spec.runtimePath;
      sourceFieldPath = spec.sourceFieldPath;
    };
    lifecycle = spec.lifecycle;
    materialAccess = "sops-nix-name-mediated";
    plaintextMaterial = false;
    providerNeutral = true;
    fixedSecretManagerRequired = true;
    gampIds = [
      "FS-820-HDS-010-SDS-010-SMS-010"
      "FS-820-HDS-010-SDS-010-SMS-020"
    ];
  }) satSecretSourceSpecs;

  satSecretSourceBindings = map (spec: {
    id = "${spec.id}-binding";
    declarationId = spec.id;
    sourceId = "${spec.id}-source";
    sourceClass = spec.sourceClass;
    bindingKind = "declaration-source";
    sourceFieldPath = spec.sourceFieldPath;
    policyAuthority = secretPolicyNeutral;
    gampIds = [
      "FS-820-HDS-010-SDS-010-SMS-010"
      "FS-820-HDS-010-SDS-010-SMS-020"
      "FS-820-HDS-010-SDS-010-SMS-030"
    ];
  }) satSecretSourceSpecs;

  operationalPrivacyContracts = {
    marker = "SAT-SRC-INVENTORY-OPERATIONAL-PRIVACY";
    sourceLayer = "network-labs/sat/inventory.nix";
    defaultHigherDetailEnabled = false;
    explicitScopedDetailModeRequired = true;
    allowedDetailSelectionContexts = [
      "modeled-context"
      "validation-context"
    ];
    metadataSurfaces = [
      {
        metadataClass = "dns-query";
        classification = "sensitive-operational-metadata";
        retention = "short";
        access = "operations-and-validation";
        redaction = "query-label-redacted";
        detailScope = [ "site" "tenant" "service" ];
        sourceLocation = "statePolicy.operationalRecords.dnsResolver";
      }
      {
        metadataClass = "client-identity";
        classification = "sensitive-operational-metadata";
        retention = "medium";
        access = "operations-and-validation";
        redaction = "pseudonymous-client-ref";
        detailScope = [ "site" "tenant" "host" ];
        sourceLocation = "statePolicy.operationalRecords.dhcp4Leases";
      }
      {
        metadataClass = "service-discovery";
        classification = "internal-operational-metadata";
        retention = "short";
        access = "operations";
        redaction = "service-ref";
        detailScope = [ "site" "tenant" "service" ];
        sourceLocation = "statePolicy.operationalRecords.dnsService";
      }
      {
        metadataClass = "flow-summary";
        classification = "sensitive-operational-metadata";
        retention = "short";
        access = "operations-and-validation";
        redaction = "aggregate-flow-ref";
        detailScope = [ "site" "tenant" "host" "service" ];
        sourceLocation = "statePolicy.operationalRecords.relatedServices";
      }
      {
        metadataClass = "lease-state";
        classification = "internal-operational-metadata";
        retention = "medium";
        access = "operations-and-validation";
        redaction = "address-ref";
        detailScope = [ "site" "tenant" "interface" ];
        sourceLocation = "statePolicy.operationalRecords.dhcp4Leases";
      }
      {
        metadataClass = "provider-state";
        classification = "internal-operational-metadata";
        retention = "medium";
        access = "operations-and-validation";
        redaction = "provider-ref";
        detailScope = [ "site" "provider" "runtime-fact-set" ];
        sourceLocation = "controlPlane.providerAccess.scenarios";
      }
      {
        metadataClass = "validation-failure-detail";
        classification = "validation-context-data";
        retention = "short";
        access = "validation";
        redaction = "evidence-ref";
        detailScope = [ "validation-row" "artifact" "runtime-target" ];
        sourceLocation = "validation-context";
      }
    ];
    gampIds = [
      "FS-910-HDS-010-SDS-010"
      "FS-910-HDS-010-SDS-010-SMS-010"
      "FS-910-HDS-010-SDS-010-SMS-020"
      "FS-910-HDS-010-SDS-010-SMS-030"
    ];
  };

  failureHandlingContracts = {
    marker = "SAT-SRC-INVENTORY-FAILURE-HANDLING";
    sourceLayer = "network-labs/sat/inventory.nix";
    responseAuthority = {
      defaultBehavior = "deny-by-default";
      unmodeledFallbackAuthority = false;
      createsDnsFallback = false;
      createsRouteFallback = false;
      createsPublicIngress = false;
      createsTenantReachability = false;
      createsManagementReachability = false;
      createsEgressAuthority = false;
    };
    modeledFailureClasses = [
      { failureClass = "provider-loss"; response = "fail-closed"; affectedSurface = "provider-access"; sourceLocation = "controlPlane.providerAccess.scenarios"; }
      { failureClass = "overlay-loss"; response = "degraded-service"; affectedSurface = "overlay"; sourceLocation = "controlPlane.sites.esp.*.overlays"; }
      { failureClass = "dns-failure"; response = "fail-closed"; affectedSurface = "dns"; sourceLocation = "services.dns"; }
      { failureClass = "route-withdrawal"; response = "fail-closed"; affectedSurface = "route-authority"; sourceLocation = "intent.esp.*.transport"; }
      { failureClass = "route-leak"; response = "fail-closed"; affectedSurface = "policy"; sourceLocation = "intent.esp.*.comms"; }
      { failureClass = "address-conflict"; response = "fail-closed"; affectedSurface = "address-authority"; sourceLocation = "intent.esp.*.ownership"; }
      { failureClass = "state-loss"; response = "retry"; affectedSurface = "statePolicy"; sourceLocation = "statePolicy.persistence"; }
      { failureClass = "ingress-conflict"; response = "fail-closed"; affectedSurface = "public-ingress"; sourceLocation = "sat/public-ingress-fixture-table.nix"; }
      { failureClass = "nat-exhaustion"; response = "degraded-service"; affectedSurface = "translation"; sourceLocation = "controlPlane.providerAccess.scenarios.*.nat.ipv4"; }
      { failureClass = "nat66-exhaustion"; response = "degraded-service"; affectedSurface = "translation"; sourceLocation = "controlPlane.providerAccess.scenarios.*.nat.ipv6"; }
      { failureClass = "secret-expiry"; response = "fail-closed"; affectedSurface = "secret-source"; sourceLocation = "secretDeclarations"; }
    ];
    gampIds = [
      "FS-920-HDS-010-SDS-011"
      "FS-920-HDS-010-SDS-012"
      "FS-920-HDS-010-SDS-013"
      "FS-920-HDS-010-SDS-010-SMS-010"
      "FS-920-HDS-010-SDS-010-SMS-020"
      "FS-920-HDS-010-SDS-010-SMS-030"
    ];
  };

  failureDiagnosticContracts = {
    marker = "SAT-SRC-INVENTORY-FAILURE-DIAGNOSTICS";
    sourceLayer = "network-labs/sat/inventory.nix";
    requiredDiagnosticFields = [
      "owningLayer"
      "affectedScope"
      "input"
      "reason"
      "sourceLocation"
    ];
    inputStates = [
      "missing"
      "stale"
      "mismatched"
      "conflicting"
      "ambiguous"
    ];
    valueClasses = [
      "behavior"
      "public-inventory"
      "protected-inventory"
      "runtime-fact"
      "target-limitation"
      "validation-context-data"
    ];
    redaction = {
      preserveCorrelation = true;
      exposePlaintextSecrets = false;
      exposeFullPayloads = false;
      exposeUnboundedDebug = false;
    };
    repairRouting = {
      routeMalformedInputToOwningSourceLayer = true;
      lowerLayerHeuristicRepairAllowed = false;
      rendererLocalRepairAllowed = false;
      scriptLocalRepairAllowed = false;
    };
    diagnosticTaxonomy = [
      { code = "missing-source-input"; owningLayer = "inventory"; valueClass = "public-inventory"; reason = "required source atom missing"; }
      { code = "protected-source-unavailable"; owningLayer = "inventory"; valueClass = "protected-inventory"; reason = "protected reference missing or inaccessible"; }
      { code = "runtime-fact-stale"; owningLayer = "inventory"; valueClass = "runtime-fact"; reason = "runtime fact freshness cannot be proven"; }
      { code = "behavior-conflict"; owningLayer = "intent"; valueClass = "behavior"; reason = "modeled behavior conflicts with another source atom"; }
      { code = "target-limitation"; owningLayer = "renderer-or-harness"; valueClass = "target-limitation"; reason = "selected target cannot realize explicit source behavior"; }
      { code = "validation-context-incomplete"; owningLayer = "validation-context"; valueClass = "validation-context-data"; reason = "validation scope or evidence input incomplete"; }
    ];
    gampIds = [
      "FS-930-HDS-010-SDS-011"
      "FS-930-HDS-010-SDS-012"
      "FS-930-HDS-010-SDS-013"
      "FS-930-HDS-010-SDS-010-SMS-010"
      "FS-930-HDS-010-SDS-010-SMS-020"
      "FS-930-HDS-010-SDS-010-SMS-030"
    ];
  };
in
{
  # SAT-SRC-INVENTORY-OPERATIONAL-PRIVACY: FS-910 controlled source records
  # for operational metadata classification, retention/access/redaction, and
  # explicit scoped detail mode.
  inherit operationalPrivacyContracts;
  # SAT-SRC-INVENTORY-FAILURE-HANDLING: FS-920 controlled source records for
  # modeled failure classes, one response per class, and deny-by-default
  # response authority.
  inherit failureHandlingContracts;
  # SAT-SRC-INVENTORY-FAILURE-DIAGNOSTICS: FS-930 controlled source records
  # for deterministic diagnostics, value redaction, and source-layer repair
  # routing.
  inherit failureDiagnosticContracts;
  # SAT-SRC-INVENTORY-SECRET-DECLARATIONS: FS-810 source construction for
  # reference-only secret declarations. These records carry metadata only; they
  # do not select sources, expose plaintext material, or create network policy.
  secretDeclarations = satSecretDeclarations;
  # SAT-SRC-INVENTORY-SECRET-SOURCE-BINDINGS: FS-820 source construction for
  # provider-neutral declaration-to-source bindings.
  secretSources = satSecretSources;
  sourceBindings = satSecretSourceBindings;
  # SAT-SRC-INVENTORY-CLAB-ROLES: SAT realization coverage for Containerlab
  # role mapping used by the s-router CLAB mirror.
  containerlab = {
    roles = {
      core = {
        forwarding = {
          disable_eth0 = false;
        };
      };
      downstream = {
        forwarding = {
          disable_eth0 = true;
        };
      };
      isp = {
        forwarding = {
          disable_eth0 = false;
        };
      };
      policy = {
        forwarding = {
          disable_eth0 = true;
        };
      };
      upstream = {
        forwarding = {
          disable_eth0 = true;
        };
      };
      wan-peer = {
        forwarding = {
          disable_eth0 = false;
        };
      };
    };
  };
  # SAT-SRC-INVENTORY-CONTROL-PLANE: SAT realization coverage for renderer
  # control-plane facts, overlays, runtime nodes, provider bindings, and
  # target-specific routing-service choices.
  controlPlane = {
    providerAccess = {
      attachments = providerAccessAttachmentRealization;
      scenarios = providerAccessRealization;
    };
    sites = {
      esp = {
        nixos = {
          overlays = {
            east-west = {
              nodes = {
                hetz-router-lighthouse = {
                  addr4 = "100.96.10.254/32";
                  addr6 = "fd42:dead:beef:ee::254/128";
                };
                nixos-router-core-nebula = {
                  addr4 = "100.96.10.1/32";
                  addr6 = "fd42:dead:beef:ee::1/128";
                };
              };
              nebula = {
                lighthouse = {
                  endpoint = "198.51.100.10";
                  endpointSourceFile = "/run/secrets/hetzner-lighthouse-public-ipv4";
                  endpoint6 = "2001:db8:51::10";
                  endpoint6SourceFile = "/run/secrets/hetzner-public-ipv6";
                  node = "hetz-router-lighthouse";
                  port = 4242;
                };
                role = "core-client";
              };
              provider = "nebula";
              # SAT-SRC-INVENTORY-PROVIDER-BOOTSTRAP-DNS: provider bootstrap
              # resolver facts are realization data only. They must stay
              # separate from customer, tenant, hostile, and Unbound DNS.
              providerBootstrapDns = {
                forwarders = [
                  "192.0.2.53"
                  "2001:db8::53"
                ];
              };
              underlayEndpointSourceFiles = {
                ipv4 = [
                  "/run/secrets/hetzner-lighthouse-public-ipv4"
                  "/run/secrets/hetzner-public-ipv4"
                ];
                ipv6 = [ "/run/secrets/hetzner-public-ipv6" ];
              };
              runtimeNodes = {
                nixos-router-core-nebula = {
                  container = {
                    profile = "core-router-nebula";
                    targetContainer = "nixos-router-core-nebula";
                  };
                  groups = [
                    "lab"
                    "core"
                  ];
                  service = {
                    interface = "overlay-west";
                    name = "nebula-runtime";
                  };
                  relay = {
                    relays = [ "hetz-router-nebula-core" ];
                  };
                };
              };
            };
          };
          routing = {
            bgp = {
              asn = 65000;
              topology = "policy-rr";
            };
            mode = "bgp";
          };
          tenants = {
            hostile = {
              ipv6 = {
                mode = "slaac";
              };
            };
          };
        };
        hetz = {
          overlays = {
            east-west = {
              nodes = {
                hetz-router-lighthouse = {
                  addr4 = "100.96.10.254/32";
                  addr6 = "fd42:dead:beef:ee::254/128";
                };
                hetz-router-nebula-core = {
                  addr4 = "100.96.10.3/32";
                  addr6 = "fd42:dead:beef:ee::3/128";
                };
              };
              nebula = {
                lighthouse = {
                  endpoint = "198.51.100.10";
                  endpointSourceFile = "/run/secrets/hetzner-lighthouse-public-ipv4";
                  endpoint6 = "2001:db8:51::10";
                  endpoint6SourceFile = "/run/secrets/hetzner-public-ipv6";
                  node = "hetz-router-lighthouse";
                  port = 4242;
                };
                role = "core-client";
              };
              provider = "nebula";
              # SAT-SRC-INVENTORY-PROVIDER-BOOTSTRAP-DNS: provider bootstrap
              # resolver facts are realization data only. They must stay
              # separate from customer, tenant, hostile, and Unbound DNS.
              providerBootstrapDns = {
                forwarders = [
                  "192.0.2.53"
                  "2001:db8::53"
                ];
              };
              underlayEndpointSourceFiles = {
                ipv4 = [
                  "/run/secrets/hetzner-lighthouse-public-ipv4"
                  "/run/secrets/hetzner-public-ipv4"
                ];
                ipv6 = [ "/run/secrets/hetzner-public-ipv6" ];
              };
              runtimeNodes = {
                hetz-router-lighthouse = {
                  container = {
                    host = "s-router-hetzner-anywhere";
                    hostBridge = "dmz";
                    profile = "core-client";
                  };
                  groups = [
                    "lab"
                    "hetz"
                    "lighthouse"
                  ];
                  service = {
                    interface = "nebula1";
                    name = "nebula-runtime";
                  };
                };
                hetz-router-nebula-core = {
                  container = {
                    host = "s-router-hetzner-anywhere";
                    profile = "core-router-nebula";
                    targetContainer = "hetz-router-nebula-core";
                  };
                  groups = [
                    "lab"
                    "hetz"
                    "core"
                  ];
                  service = {
                    interface = "overlay-west";
                    listenHost = "172.31.254.4";
                    name = "nebula-runtime";
                    port = 443;
                    publicEndpoints = [
                      {
                        endpointSourceFile = "/run/secrets/hetzner-public-ipv4";
                        port = 443;
                      }
                    ];
                  };
                  relay = {
                    amRelay = true;
                  };
                };
              };
            };
            wg-host128-egress = {
              nodes = {
                hetz-router-nebula-core = {
                  addr4 = "10.66.128.2/32";
                  addr6 = "2001:db8:128::2/128";
                };
              };
              provider = "wireguard";
              providerBootstrapDns = {
                forwarders = [
                  "192.0.2.53"
                  "2001:db8::53"
                ];
              };
              wireguard = {
                interface = "wg128";
                privateKeyFile = "/run/secrets/wireguard-sat-host128-private-key";
                peers = [
                  {
                    publicKey = "bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb=";
                    endpoint = "198.51.100.128:51820";
                    allowedIPs = [
                      "0.0.0.0/0"
                      "::/0"
                    ];
                    presharedKeyFile = "/run/secrets/wireguard-sat-host128-psk";
                    persistentKeepalive = 25;
                  }
                ];
                providerContract = wireguardProviderContracts.hostOnly128Egress;
                role = "provider-server";
              };
            };
            wg-routed64 = {
              nodes = {
                hetz-router-nebula-core = {
                  addr4 = "10.66.64.2/32";
                  addr6 = "2001:db8:64::2/128";
                };
              };
              provider = "wireguard";
              providerBootstrapDns = {
                forwarders = [
                  "192.0.2.53"
                  "2001:db8::53"
                ];
              };
              wireguard = {
                interface = "wg64";
                privateKeyFile = "/run/secrets/wireguard-sat-routed64-private-key";
                peers = [
                  {
                    publicKey = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa=";
                    endpoint = "198.51.100.64:51821";
                    allowedIPs = [
                      "0.0.0.0/0"
                      "::/0"
                    ];
                    presharedKeyFile = "/run/secrets/wireguard-sat-routed64-psk";
                    persistentKeepalive = 25;
                  }
                ];
                providerContract = wireguardProviderContracts.routed64;
                role = "provider-server";
              };
            };
          };
          routing = {
            bgp = {
              asn = 65020;
              topology = "policy-rr";
            };
            mode = "bgp";
          };
          tenants = {
            client = { };
          };
        };
        clab = {
          overlays = {
            east-west = {
              nodes = {
                clab-router-core-nebula = {
                  addr4 = "100.96.10.2/32";
                  addr6 = "fd42:dead:beef:ee::2/128";
                };
                branch-node01 = {
                  addr4 = "100.96.10.20/32";
                  addr6 = "fd42:dead:beef:ee::20/128";
                };
                hetz-router-lighthouse = {
                  addr4 = "100.96.10.254/32";
                  addr6 = "fd42:dead:beef:ee::254/128";
                };
                hostile-node01 = {
                  addr4 = "100.96.10.30/32";
                  addr6 = "fd42:dead:beef:ee::30/128";
                };
              };
              nebula = {
                lighthouse = {
                  endpoint = "198.51.100.10";
                  endpointSourceFile = "/run/secrets/hetzner-lighthouse-public-ipv4";
                  endpoint6 = "2001:db8:51::10";
                  endpoint6SourceFile = "/run/secrets/hetzner-public-ipv6";
                  node = "hetz-router-lighthouse";
                  port = 4242;
                };
                role = "core-client";
              };
              provider = "nebula";
              # SAT-SRC-INVENTORY-PROVIDER-BOOTSTRAP-DNS: provider bootstrap
              # resolver facts are realization data only. They must stay
              # separate from customer, tenant, hostile, and Unbound DNS.
              providerBootstrapDns = {
                forwarders = [
                  "192.0.2.53"
                  "2001:db8::53"
                ];
              };
              underlayEndpointSourceFiles = {
                ipv4 = [
                  "/run/secrets/hetzner-lighthouse-public-ipv4"
                  "/run/secrets/hetzner-public-ipv4"
                ];
                ipv6 = [ "/run/secrets/hetzner-public-ipv6" ];
              };
              runtimeNodes = {
                clab-router-core-nebula = {
                  container = {
                    profile = "core-router-nebula";
                    targetContainer = "clab-router-core-nebula";
                  };
                  groups = [
                    "lab"
                    "branch"
                    "core"
                  ];
                  service = {
                    interface = "overlay-west";
                    name = "nebula-runtime";
                  };
                  relay = {
                    relays = [ "hetz-router-nebula-core" ];
                  };
                };
              };
            };
          };
          routing = {
            bgp = {
              asn = 65100;
              topology = "policy-rr";
            };
            mode = "bgp";
          };
          tenants = {
            admin = {
              ipv6 = {
                mode = "slaac";
              };
            };
            client = {
              ipv6 = {
                mode = "slaac";
              };
            };
            dmz = {
              ipv6 = {
                mode = "slaac";
              };
            };
            hostile = {
              ipv6 = {
                mode = "slaac";
              };
            };
            mgmt = {
              ipv6 = {
                mode = "slaac";
              };
            };
            streaming = {
              ipv6 = {
                mode = "slaac";
              };
            };
          };
        };
      };
    };
  };
  # SAT-SRC-INVENTORY-DEPLOYMENT: SAT realization coverage for harness hosts,
  # bridge networks, VLAN attachments, management boundaries, and runtime
  # placement.
  deployment = {
    hosts = {
      s-router-hetzner-anywhere = {
        bridgeNetworks = {
          br-hetz-core-upstream = { };
          br-hetz-nebula-core-upstream = { };
          br-hetz-downstream-client = { };
          br-hetz-downstream-dmz = { };
          br-hetz-downstream-policy-access-client = { };
          br-hetz-downstream-policy-access-dmz = { };
          br-hetz-policy-upstream-access-client-east-west = { };
          br-hetz-policy-upstream-access-client-wan = { };
          br-hetz-policy-upstream-access-dmz-east-west = { };
          br-hetz-policy-upstream-access-dmz-wan = { };
          client = { };
          dmz = { };
        };
        uplinks = {
          wan = {
            bridge = "br-wan";
            hostAddresses = [
              "172.31.254.1/24"
              "fd42:dead:cafe:ffff::1/64"
            ];
            ipv4 = {
              dhcp = true;
              enable = true;
              method = "dhcp";
            };
            ipv6 = {
              acceptRA = true;
              dhcp = false;
              dhcpv6PD = false;
              enable = true;
              method = "slaac";
            };
            mode = "native";
            parent = "enp1s0";
          };
        };
        wanUplink = "wan";
      };
      s-router-hetz = {
        bridgeNetworks = {
          br-hetz-core-upstream = { };
          br-hetz-nebula-core-upstream = { };
          br-hetz-downstream-client = { };
          br-hetz-downstream-dmz = { };
          br-hetz-downstream-policy-access-client = { };
          br-hetz-downstream-policy-access-dmz = { };
          br-hetz-policy-upstream-access-client-east-west = { };
          br-hetz-policy-upstream-access-client-wan = { };
          br-hetz-policy-upstream-access-dmz-east-west = { };
          br-hetz-policy-upstream-access-dmz-wan = { };
          client = { };
          dmz = { };
        };
        uplinks = {
          management = {
            ipv4 = {
              dhcp = true;
              enable = true;
              method = "dhcp";
            };
            ipv6 = {
              acceptRA = false;
              dhcp = false;
              dhcpv6PD = false;
              enable = false;
              method = "none";
            };
            mode = "native";
            parent = "enp1s0";
          };
          wan = {
            bridge = "br-wan";
            hostAddresses = [
              "172.31.254.1/24"
              "fd42:dead:cafe:ffff::1/64"
            ];
            ipv4 = {
              dhcp = true;
              enable = true;
              method = "dhcp";
            };
            ipv6 = {
              acceptRA = true;
              dhcp = false;
              dhcpv6PD = false;
              enable = true;
              method = "slaac";
            };
            mode = "native";
            parent = "enp1s0";
          };
        };
        wanUplink = "wan";
      };
      s-router-test = {
        bridgeNetworks = {
          admin = {
            mode = "vlan";
            parent = "eth0";
            vlan = 301;
          };
          br-nixos-core-isp-a-upstream = { };
          br-nixos-core-isp-b-upstream = { };
          br-nixos-core-nebula-upstream = { };
          br-nixos-downstream-admin = { };
          br-nixos-downstream-client = { };
          br-nixos-downstream-dmz = { };
          br-nixos-downstream-hostile = { };
          br-nixos-downstream-mgmt = { };
          br-nixos-downstream-policy-access-admin = { };
          br-nixos-downstream-policy-access-client = { };
          br-nixos-downstream-policy-access-dmz = { };
          br-nixos-downstream-policy-access-hostile = { };
          br-nixos-downstream-policy-access-mgmt = { };
          br-nixos-downstream-policy-access-streaming = { };
          br-nixos-downstream-streaming = { };
          br-nixos-policy-upstream-access-admin-isp-a = { };
          br-nixos-policy-upstream-access-admin-isp-b = { };
          br-nixos-policy-upstream-access-client-isp-a = { };
          br-nixos-policy-upstream-access-client-isp-b = { };
          br-nixos-policy-upstream-access-hostile-east-west = { };
          br-nixos-policy-upstream-access-mgmt-isp-a = { };
          br-nixos-policy-upstream-access-mgmt-isp-b = { };
          br-nixos-policy-upstream-access-streaming-isp-a = { };
          br-nixos-policy-upstream-access-streaming-isp-b = { };
          br-nixos-policy-upstream-access-dmz-isp-a = { };
          br-nixos-policy-upstream-access-dmz-isp-b = { };
          br-nix-pppoe = {
            hatPurpose = "residential-pppoe-handoff";
            isolated = true;
          };
          br-hetz-core-upstream = { };
          br-hetz-downstream-mgmt = { };
          br-hetz-downstream-policy-access-mgmt = { };
          br-hetz-policy-upstream-access-mgmt-wan = { };
          branch = {
            mode = "vlan";
            parent = "eth0";
            vlan = 305;
          };
          client = {
            mode = "vlan";
            parent = "eth0";
            vlan = 302;
          };
          dmz = {
            mode = "vlan";
            parent = "eth0";
            vlan = 304;
          };
          hostile = {
            mode = "vlan";
            parent = "eth0";
            vlan = 306;
          };
          mgmt = {
            mode = "vlan";
            parent = "eth0";
            vlan = 300;
          };
          streaming = {
            mode = "vlan";
            parent = "eth0";
            vlan = 311;
          };
        };
        uplinks = {
          management = {
            bridge = "vlan2";
            ipv4 = {
              dhcp = true;
              enable = true;
              method = "dhcp";
            };
            ipv6 = {
              acceptRA = false;
              dhcp = false;
              dhcpv6PD = false;
              enable = false;
              method = "none";
            };
            mode = "vlan";
            parent = "eth0";
            vlan = 2;
          };
          uplink-isp-a = {
            bridge = "br-uplink0";
            ipv4 = {
              dhcp = true;
              enable = true;
              method = "dhcp";
            };
            ipv6 = {
              acceptRA = true;
              dhcp = false;
              dhcpv6PD = false;
              enable = true;
              method = "slaac";
            };
            mode = "vlan";
            parent = "eth0";
            upstream = "isp-a";
            vlan = 4;
          };
          uplink-isp-b = {
            bridge = "br-uplink1";
            ipv4 = {
              dhcp = true;
              enable = true;
              method = "dhcp";
            };
            ipv6 = {
              acceptRA = true;
              dhcp = false;
              dhcpv6PD = false;
              enable = true;
              method = "slaac";
            };
            mode = "vlan";
            parent = "eth0";
            upstream = "isp-b";
            vlan = 5;
          };
        };
        wanUplink = "uplink-isp-b";
      };
      s-router-nixos = {
        bridgeNetworks = {
          admin = {
            mode = "vlan";
            parent = "eth0";
            vlan = 301;
          };
          br-nixos-core-isp-a-upstream = { };
          br-nixos-core-isp-b-upstream = { };
          br-nixos-core-nebula-upstream = { };
          br-nixos-downstream-admin = { };
          br-nixos-downstream-client = { };
          br-nixos-downstream-dmz = { };
          br-nixos-downstream-hostile = { };
          br-nixos-downstream-mgmt = { };
          br-nixos-downstream-policy-access-admin = { };
          br-nixos-downstream-policy-access-client = { };
          br-nixos-downstream-policy-access-dmz = { };
          br-nixos-downstream-policy-access-hostile = { };
          br-nixos-downstream-policy-access-mgmt = { };
          br-nixos-downstream-policy-access-streaming = { };
          br-nixos-downstream-streaming = { };
          br-nixos-policy-upstream-access-admin-isp-a = { };
          br-nixos-policy-upstream-access-admin-isp-b = { };
          br-nixos-policy-upstream-access-client-isp-a = { };
          br-nixos-policy-upstream-access-client-isp-b = { };
          br-nixos-policy-upstream-access-dmz-isp-a = { };
          br-nixos-policy-upstream-access-dmz-isp-b = { };
          br-nixos-policy-upstream-access-hostile-east-west = { };
          br-nixos-policy-upstream-access-mgmt-isp-a = { };
          br-nixos-policy-upstream-access-mgmt-isp-b = { };
          br-nixos-policy-upstream-access-streaming-isp-a = { };
          br-nixos-policy-upstream-access-streaming-isp-b = { };
          br-nix-pppoe = {
            hatPurpose = "residential-pppoe-handoff";
            isolated = true;
          };
          client = {
            mode = "vlan";
            parent = "eth0";
            vlan = 302;
          };
          dmz = {
            mode = "vlan";
            parent = "eth0";
            vlan = 304;
          };
          hostile = {
            mode = "vlan";
            parent = "eth0";
            vlan = 306;
          };
          mgmt = {
            mode = "vlan";
            parent = "eth0";
            vlan = 300;
          };
          streaming = {
            mode = "vlan";
            parent = "eth0";
            vlan = 311;
          };
        };
        uplinks = {
          management = {
            bridge = "vlan2";
            ipv4 = {
              dhcp = true;
              enable = true;
              method = "dhcp";
            };
            ipv6 = {
              acceptRA = false;
              dhcp = false;
              dhcpv6PD = false;
              enable = false;
              method = "none";
            };
            mode = "vlan";
            parent = "eth0";
            vlan = 2;
          };
          uplink-isp-a = {
            bridge = "br-uplink0";
            ipv4 = {
              dhcp = true;
              enable = true;
              method = "dhcp";
            };
            ipv6 = {
              acceptRA = true;
              dhcp = false;
              dhcpv6PD = false;
              enable = true;
              method = "slaac";
            };
            mode = "vlan";
            parent = "eth0";
            upstream = "isp-a";
            vlan = 4;
          };
          uplink-isp-b = {
            bridge = "br-uplink1";
            ipv4 = {
              dhcp = true;
              enable = true;
              method = "dhcp";
            };
            ipv6 = {
              acceptRA = true;
              dhcp = false;
              dhcpv6PD = false;
              enable = true;
              method = "slaac";
            };
            mode = "vlan";
            parent = "eth0";
            upstream = "isp-b";
            vlan = 5;
          };
        };
        wanUplink = "uplink-isp-b";
      };
      s-router-clab = {
        bridgeNetworks = {
          admin = {
            mode = "vlan";
            parent = "eth0";
            vlan = 301;
          };
          br-clab-core-simulated-isp-upstream = { };
          br-clab-core-nebula-upstream = { };
          br-clab-downstream-admin = { };
          br-clab-downstream-client = { };
          br-clab-downstream-dmz = { };
          br-clab-downstream-hostile = { };
          br-clab-downstream-mgmt = { };
          br-clab-downstream-streaming = { };
          br-clab-downstream-policy-access-admin = { };
          br-clab-downstream-policy-access-client = { };
          br-clab-downstream-policy-access-dmz = { };
          br-clab-downstream-policy-access-hostile = { };
          br-clab-downstream-policy-access-mgmt = { };
          br-clab-downstream-policy-access-streaming = { };
          br-clab-policy-upstream-access-admin = { };
          br-clab-policy-upstream-access-admin-east-west = { };
          br-clab-policy-upstream-access-client = { };
          br-clab-policy-upstream-access-client-east-west = { };
          br-clab-policy-upstream-access-dmz = { };
          br-clab-policy-upstream-access-dmz-east-west = { };
          br-clab-policy-upstream-access-hostile = { };
          br-clab-policy-upstream-access-hostile-east-west = { };
          br-clab-policy-upstream-access-mgmt = { };
          br-clab-policy-upstream-access-mgmt-east-west = { };
          br-clab-policy-upstream-access-streaming = { };
          br-clab-policy-upstream-access-streaming-east-west = { };
          br-clab-pppoe = {
            hatPurpose = "residential-pppoe-handoff";
            isolated = true;
          };
          branch = {
            mode = "vlan";
            parent = "eth0";
            vlan = 305;
          };
          client = {
            mode = "vlan";
            parent = "eth0";
            vlan = 302;
          };
          dmz = {
            mode = "vlan";
            parent = "eth0";
            vlan = 304;
          };
          hostile = {
            mode = "vlan";
            parent = "eth0";
            vlan = 306;
          };
          mgmt = {
            mode = "vlan";
            parent = "eth0";
            vlan = 300;
          };
          streaming = {
            mode = "vlan";
            parent = "eth0";
            vlan = 311;
          };
        };
        uplinks = {
          management = {
            bridge = "vlan2";
            ipv4 = {
              dhcp = true;
              enable = true;
              method = "dhcp";
            };
            ipv6 = {
              acceptRA = false;
              dhcp = false;
              dhcpv6PD = false;
              enable = false;
              method = "none";
            };
            mode = "vlan";
            parent = "eth0";
            vlan = 2;
          };
          uplink-isp-a = {
            bridge = "br-uplink0";
            ipv4 = {
              dhcp = true;
              enable = true;
              method = "dhcp";
            };
            ipv6 = {
              acceptRA = true;
              dhcp = false;
              dhcpv6PD = false;
              enable = true;
              method = "slaac";
            };
            mode = "vlan";
            parent = "eth0";
            upstream = "isp-a";
            vlan = 4;
          };
          uplink-isp-b = {
            bridge = "br-uplink1";
            ipv4 = {
              dhcp = true;
              enable = true;
              method = "dhcp";
            };
            ipv6 = {
              acceptRA = true;
              dhcp = false;
              dhcpv6PD = false;
              enable = true;
              method = "slaac";
            };
            mode = "vlan";
            parent = "eth0";
            upstream = "isp-b";
            vlan = 5;
          };
        };
        wanUplink = "uplink-isp-b";
      };
      s-router-test-clients = {
        bridgeNetworks = {
          admin = {
            mode = "vlan";
            parent = "eth0";
            vlan = 301;
          };
          branch = {
            mode = "vlan";
            parent = "eth0";
            vlan = 305;
          };
          client = {
            mode = "vlan";
            parent = "eth0";
            vlan = 302;
          };
          dmz = {
            mode = "vlan";
            parent = "eth0";
            vlan = 304;
          };
          hostile = {
            mode = "vlan";
            parent = "eth0";
            vlan = 306;
          };
          mgmt = {
            mode = "vlan";
            parent = "eth0";
            vlan = 300;
          };
          streaming = {
            mode = "vlan";
            parent = "eth0";
            vlan = 311;
          };
        };
        hat = {
          requiredEndpointClients = [
            "nixos-branch-node01"
            "nixos-client01"
            "nixos-client02"
            "nixos-emulated-sigma"
            "nixos-printer01"
            "nixos-receiver01"
            "nixos-streaming-test"
          ];
          endpointClients = {
            nixos-branch-node01 = {
              addressDelivery = "endpoint-configured";
              assignment = "static-ipv4-or-ipv6-client";
              bridge = "branch";
              gateway4 = "10.60.10.1";
              gateway6 = "fd42:dead:feed:10::1";
              ipv4 = [ "10.60.10.10/24" ];
              ipv6 = [ "fd42:dead:feed:10::10/64" ];
              managementBoundary = {
                fixturePlacementCreatesManagementAccess = false;
                mode = "no-general-management";
              };
              owningSubstrate = "nixos";
              persistenceExpectation = {
                kind = "ephemeral-fixture";
                required = false;
              };
              tenant = "branch";
            };
            nixos-client01 = {
              assignment = "dhcp";
              bridge = "client";
              managementBoundary = {
                fixturePlacementCreatesManagementAccess = false;
                mode = "no-general-management";
              };
              owningSubstrate = "nixos";
              persistenceExpectation = {
                kind = "ephemeral-fixture";
                required = false;
              };
              tenant = "client";
            };
            nixos-client02 = {
              assignment = "dhcp";
              bridge = "client";
              managementBoundary = {
                fixturePlacementCreatesManagementAccess = false;
                mode = "no-general-management";
              };
              owningSubstrate = "nixos";
              persistenceExpectation = {
                kind = "ephemeral-fixture";
                required = false;
              };
              tenant = "client";
            };
            nixos-emulated-sigma = {
              addressDelivery = "endpoint-configured";
              assignment = "static-ipv4-or-ipv6-client";
              bridge = "mgmt";
              gateway4 = "10.20.10.1";
              gateway6 = "fd42:dead:beef:10::1";
              ipv4 = [ "10.20.10.50/24" ];
              ipv6 = [ "fd42:dead:beef:10::50/64" ];
              managementBoundary = {
                fixturePlacementCreatesManagementAccess = false;
                mode = "no-general-management";
              };
              owningSubstrate = "nixos";
              persistenceExpectation = {
                kind = "ephemeral-fixture";
                required = false;
              };
              tenant = "mgmt";
            };
            nixos-printer01 = {
              addressDelivery = "endpoint-configured";
              assignment = "static-ipv4-or-ipv6-client";
              bridge = "client";
              gampId = "FS-730-HDS-010-SDS-010-SMS-010";
              gateway4 = "10.20.20.1";
              gateway6 = "fd42:dead:beef:20::1";
              ipv4 = [ "10.20.20.60/24" ];
              ipv6 = [ "fd42:dead:beef:20::60/64" ];
              fixtureAuthority = {
                gampId = "FS-730-HDS-010-SDS-010-SMS-030";
                mayGrantManagementAccess = false;
                mayInferPolicy = false;
                policyAuthority = "intent-communication-contract";
              };
              managementBoundary = {
                fixturePlacementCreatesManagementAccess = false;
                mode = "declared-service-surfaces-only";
              };
              owningSubstrate = "nixos";
              persistenceExpectation = {
                gampId = "FS-730-HDS-010-SDS-010-SMS-030";
                kind = "persistent-service-state";
                paths = [ "/var/lib/cups" ];
                required = true;
                service = "cups";
              };
              serviceState = {
                gampId = "FS-730-HDS-010-SDS-010-SMS-020";
                required = true;
                service = "cups";
                systemdUnit = "cups.service";
                targetState = "running";
              };
              serviceSurfaces = {
                admin = {
                  gampId = "FS-740-HDS-010-SDS-010-SMS-010";
                  ports = [ 80 ];
                  protocol = "tcp";
                  service = "hat-printer-admin";
                };
                ipp = {
                  gampId = "FS-730-HDS-010-SDS-010-SMS-010";
                  ports = [ 631 ];
                  protocol = "tcp";
                  service = "hat-printer-ipp";
                };
              };
              tenant = "client";
              vm = {
                gampId = "FS-730-HDS-010-SDS-010-SMS-010";
                kind = "nixos-vm";
                role = "cups-printer";
                service = "cups";
              };
            };
            nixos-receiver01 = {
              addressDelivery = "endpoint-configured";
              assignment = "static-ipv4-or-ipv6-client";
              bridge = "client";
              gampId = "FS-750-HDS-010-SDS-010-SMS-010";
              gateway4 = "10.20.20.1";
              gateway6 = "fd42:dead:beef:20::1";
              ipv4 = [ "10.20.20.70/24" ];
              ipv6 = [ "fd42:dead:beef:20::70/64" ];
              fixtureAuthority = {
                gampId = "FS-750-HDS-010-SDS-010-SMS-030";
                mayGrantDiscovery = false;
                mayGrantManagementAccess = false;
                mayGrantMulticastForwarding = false;
                mayGrantPayloadAccess = false;
                mayGrantReverseInitiation = false;
                mayGrantTenantReachability = false;
                mayInferPolicy = false;
                policyAuthority = "intent-communication-contract";
              };
              managementBoundary = {
                fixturePlacementCreatesManagementAccess = false;
                mode = "no-general-management";
              };
              owningSubstrate = "nixos";
              persistenceExpectation = {
                kind = "ephemeral-fixture";
                required = false;
              };
              serviceSurfaces = {
                control = {
                  gampId = "FS-750-HDS-010-SDS-010-SMS-020";
                  ports = [
                    8008
                    8009
                  ];
                  protocol = "tcp";
                  service = "hat-receiver-control";
                };
                discovery = {
                  gampId = "FS-760-HDS-010-SDS-010-SMS-010";
                  ports = [
                    5353
                    1900
                  ];
                  protocol = "udp";
                  service = "hat-receiver-discovery";
                };
              };
              tenant = "client";
            };
            nixos-streaming-test = {
              addressDelivery = "endpoint-configured";
              assignment = "static-ipv4-or-ipv6-client";
              bridge = "streaming";
              gateway4 = "10.20.50.1";
              gateway6 = "fd42:dead:beef:50::1";
              ipv4 = [ "10.20.50.10/24" ];
              ipv6 = [ "fd42:dead:beef:50::10/64" ];
              managementBoundary = {
                fixturePlacementCreatesManagementAccess = false;
                mode = "no-general-management";
              };
              owningSubstrate = "nixos";
              persistenceExpectation = {
                kind = "ephemeral-fixture";
                required = false;
              };
              tenant = "streaming";
            };
            clab-client01 = {
              assignment = "dhcp";
              bridge = "client";
              managementBoundary = {
                fixturePlacementCreatesManagementAccess = false;
                mode = "no-general-management";
              };
              owningSubstrate = "clab";
              persistenceExpectation = {
                kind = "ephemeral-fixture";
                required = false;
              };
              tenant = "client";
            };
            clab-client02 = {
              assignment = "dhcp";
              bridge = "client";
              managementBoundary = {
                fixturePlacementCreatesManagementAccess = false;
                mode = "no-general-management";
              };
              owningSubstrate = "clab";
              persistenceExpectation = {
                kind = "ephemeral-fixture";
                required = false;
              };
              tenant = "client";
            };
            clab-emulated-sigma = {
              addressDelivery = "endpoint-configured";
              assignment = "static-ipv4-or-ipv6-client";
              bridge = "mgmt";
              gateway4 = "10.50.10.1";
              gateway6 = "fd42:dead:feed:10::1";
              ipv4 = [ "10.50.10.50/24" ];
              ipv6 = [ "fd42:dead:feed:10::50/64" ];
              managementBoundary = {
                fixturePlacementCreatesManagementAccess = false;
                mode = "no-general-management";
              };
              owningSubstrate = "clab";
              persistenceExpectation = {
                kind = "ephemeral-fixture";
                required = false;
              };
              tenant = "mgmt";
            };
          };
        };
        uplinks = {
          management = {
            bridge = "vlan2";
            ipv4 = {
              dhcp = true;
              enable = true;
              method = "dhcp";
            };
            ipv6 = {
              acceptRA = false;
              dhcp = false;
              dhcpv6PD = false;
              enable = false;
              method = "none";
            };
            mode = "vlan";
            parent = "eth0";
            vlan = 2;
          };
        };
      };
    };
  };
  # SAT-SRC-INVENTORY-ENDPOINTS: SAT realization coverage for endpoint/client
  # placement and client validation contexts.
  endpoints = satEndpointAddresses;
  # SAT-SRC-INVENTORY-REALIZATION: SAT realization coverage for concrete nodes,
  # ports, services, secrets, DHCP/RA, DNS service placement, and provider
  # runtime facts.
  realization = {
    nodes = withSatStatePolicy {
      esp-nixos-router-access-admin = {
        advertisements = {
          dhcp4 = {
            tenant-admin = {
              dnsServers = [ "router-self" ];
              domain = "lan.";
            };
          };
          ipv6Ra = {
            tenant-admin = {
              dnssl = [ "lan." ];
              rdnss = [ "router-self" ];
            };
          };
        };
        host = "s-router-nixos";
        logicalNode = {
          enterprise = "esp";
          name = "nixos-router-access-admin";
          site = "nixos";
        };
        platform = "nixos-container";
        ports = {
          tenant-admin = {
            attach = {
              bridge = "admin";
              kind = "bridge";
            };
            interface = {
              name = "tenant-admin";
            };
            logicalInterface = "tenant-admin";
          };
          transit-downstream = {
            adapterName = "p2p-nixos-router-access-admin-nixos-router-downstream-transit-downstream";
            attach = {
              bridge = "br-nixos-downstream-admin";
              kind = "bridge";
            };
            interface = {
              name = "transit";
            };
            link = "p2p-nixos-router-access-admin-nixos-router-downstream";
          };
        };
        services = {
          dns = withDeniedResolverCidrs { };
        };
      };
      esp-nixos-router-access-client = {
        advertisements = {
          dhcp4 = {
            tenant-client = {
              dnsServers = [ "router-self" ];
              domain = "lan.";
              # SAT-SRC-INVENTORY-STATIC-RESERVATION: controlled static
              # client reservation source for DHCP and DHCPv6 reservation
              # projection through CPM and renderers.
              reservations = [
                {
                  name = "nixos-client-fixed-10";
                  hostname = "nixos-client-fixed-10";
                  mac = "02:10:20:00:00:10";
                  macSource = {
                    accepted = true;
                    disposable = true;
                    purpose = "static-dhcp-reservation";
                    sourceClass = "public-synthetic-lab";
                  };
                  namespaceOwner = "tenant-client";
                  requesterScope = "tenant-client";
                  recordClass = "dhcp4-lease-name";
                  conflictBehavior = "fail-closed";
                  staleRecordBehavior = "fail-closed-deny-answer";
                  fallbackBehavior = "blocked-no-public-recursion";
                  deniedClasses = [
                    "recursive-dns-authority"
                    "payload-reachability"
                    "management-reachability"
                    "public-egress"
                  ];
                  leaseRevocationBehavior = "remove-lease-name-on-client-revocation";
                  ipv4.hostOffset = 10;
                }
              ];
            };
          };
          dhcpv6 = {
            tenant-client = {
              dnsServers = [ "router-self" ];
              domain = "lan.";
              pool = {
                start = "fd42:dead:beef:20::100";
                end = "fd42:dead:beef:20::1ff";
              };
              reservations = [
                {
                  name = "nixos-client-fixed-10";
                  hostname = "nixos-client-fixed-10";
                  mac = "02:10:20:00:00:10";
                  macSource = {
                    accepted = true;
                    disposable = true;
                    purpose = "dhcpv6-reservation";
                    sourceClass = "public-synthetic-lab";
                  };
                  namespaceOwner = "tenant-client";
                  requesterScope = "tenant-client";
                  recordClass = "dhcpv6-lease-name";
                  conflictBehavior = "fail-closed";
                  staleRecordBehavior = "fail-closed-deny-answer";
                  fallbackBehavior = "blocked-no-public-recursion";
                  deniedClasses = [
                    "recursive-dns-authority"
                    "payload-reachability"
                    "management-reachability"
                    "public-egress"
                  ];
                  leaseRevocationBehavior = "remove-lease-name-on-client-revocation";
                  ipv6.hostOffset = 16;
                }
              ];
            };
          };
          ipv6Ra = {
            tenant-client = {
              dnssl = [ "lan." ];
              rdnss = [ "router-self" ];
            };
          };
        };
        host = "s-router-nixos";
        logicalNode = {
          enterprise = "esp";
          name = "nixos-router-access-client";
          site = "nixos";
        };
        platform = "nixos-container";
        ports = {
          tenant-client = {
            attach = {
              bridge = "client";
              kind = "bridge";
            };
            interface = {
              name = "tenant-client";
            };
            logicalInterface = "tenant-client";
          };
          transit-downstream = {
            adapterName = "p2p-nixos-router-access-client-nixos-router-downstream-transit-downstream";
            attach = {
              bridge = "br-nixos-downstream-client";
              kind = "bridge";
            };
            interface = {
              name = "transit";
            };
            link = "p2p-nixos-router-access-client-nixos-router-downstream";
          };
        };
        services = {
          dns = withDeniedResolverCidrs { };
        };
      };
      esp-nixos-router-access-dmz = {
        advertisements = {
          dhcp4 = {
            tenant-dmz = {
              dnsServers = [ "router-self" ];
              domain = "lan.";
            };
          };
          ipv6Ra = {
            tenant-dmz = {
              dnssl = [ "lan." ];
              rdnss = [ "router-self" ];
            };
          };
        };
        host = "s-router-nixos";
        logicalNode = {
          enterprise = "esp";
          name = "nixos-router-access-dmz";
          site = "nixos";
        };
        platform = "nixos-container";
        ports = {
          tenant-dmz = {
            attach = {
              bridge = "dmz";
              kind = "bridge";
            };
            interface = {
              name = "tenant-dmz";
            };
            logicalInterface = "tenant-dmz";
          };
          transit-downstream = {
            adapterName = "p2p-nixos-router-access-dmz-nixos-router-downstream-transit-downstream";
            attach = {
              bridge = "br-nixos-downstream-dmz";
              kind = "bridge";
            };
            interface = {
              name = "transit";
            };
            link = "p2p-nixos-router-access-dmz-nixos-router-downstream";
          };
        };
        services = {
          dns = withDeniedResolverCidrs {
            advertised = {
              dnsServers = [ "router-self" ];
              rdnss = [ "router-self" ];
            };
          };
        };
      };
      esp-nixos-router-access-hostile = {
        advertisements = {
          dhcp4 = {
            tenant-hostile = {
              dnsServers = [ "router-self" ];
              domain = "lan.";
            };
          };
          ipv6Ra = {
            tenant-hostile = {
              dnssl = [ "lan." ];
              rdnss = [ "router-self" ];
            };
          };
        };
        host = "s-router-nixos";
        logicalNode = {
          enterprise = "esp";
          name = "nixos-router-access-hostile";
          site = "nixos";
        };
        platform = "nixos-container";
        ports = {
          tenant-hostile = {
            attach = {
              bridge = "hostile";
              kind = "bridge";
            };
            interface = {
              name = "tenant-hostile";
            };
            logicalInterface = "tenant-hostile";
          };
          transit-downstream = {
            adapterName = "p2p-nixos-router-access-hostile-nixos-router-downstream-transit-downstream";
            attach = {
              bridge = "br-nixos-downstream-hostile";
              kind = "bridge";
            };
            interface = {
              name = "transit";
            };
            link = "p2p-nixos-router-access-hostile-nixos-router-downstream";
          };
        };
        services = {
          dns = withDeniedResolverCidrs { };
        };
      };
      esp-nixos-router-access-mgmt = {
        advertisements = {
          dhcp4 = {
            tenant-mgmt = {
              dnsServers = [ "router-self" ];
              domain = "lan.";
            };
          };
          ipv6Ra = {
            tenant-mgmt = {
              dnssl = [ "lan." ];
              rdnss = [ "router-self" ];
            };
          };
        };
        host = "s-router-nixos";
        logicalNode = {
          enterprise = "esp";
          name = "nixos-router-access-mgmt";
          site = "nixos";
        };
        platform = "nixos-container";
        ports = {
          tenant-mgmt = {
            attach = {
              bridge = "mgmt";
              kind = "bridge";
            };
            interface = {
              name = "tenant-mgmt";
            };
            logicalInterface = "tenant-mgmt";
          };
          transit-downstream = {
            adapterName = "p2p-nixos-router-access-mgmt-nixos-router-downstream-transit-downstream";
            attach = {
              bridge = "br-nixos-downstream-mgmt";
              kind = "bridge";
            };
            interface = {
              name = "transit";
            };
            link = "p2p-nixos-router-access-mgmt-nixos-router-downstream";
          };
        };
        services = {
          dns = withDeniedResolverCidrs { };
        };
      };
      esp-nixos-router-access-streaming = {
        advertisements = {
          dhcp4 = {
            tenant-streaming = {
              dnsServers = [ "router-self" ];
              domain = "lan.";
            };
          };
          ipv6Ra = {
            tenant-streaming = {
              dnssl = [ "lan." ];
              rdnss = [ "router-self" ];
            };
          };
        };
        host = "s-router-nixos";
        logicalNode = {
          enterprise = "esp";
          name = "nixos-router-access-streaming";
          site = "nixos";
        };
        platform = "nixos-container";
        ports = {
          tenant-streaming = {
            attach = {
              bridge = "streaming";
              kind = "bridge";
            };
            interface = {
              name = "tenant-stream";
            };
            logicalInterface = "tenant-streaming";
          };
          transit-downstream = {
            adapterName = "p2p-nixos-router-access-streaming-nixos-router-downstream-transit-downstream";
            attach = {
              bridge = "br-nixos-downstream-streaming";
              kind = "bridge";
            };
            interface = {
              name = "transit";
            };
            link = "p2p-nixos-router-access-streaming-nixos-router-downstream";
          };
        };
        services = {
          dns = withDeniedResolverCidrs { };
        };
      };
      esp-nixos-router-core-isp-a = withDeniedResolverNode {
        host = "s-router-nixos";
        logicalNode = {
          enterprise = "esp";
          name = "nixos-router-core-isp-a";
          site = "nixos";
        };
        platform = "nixos-container";
        ports = {
          isp-a = {
            attach = {
              bridge = "br-uplink0";
              kind = "bridge";
            };
            external = true;
            interface = {
              name = "isp-a";
              # SAT-SRC-INVENTORY-MTU: records explicit MTU source
              # provenance; MTU is an inventory realization fact, not
              # renderer inference.
              mtu = 1492;
            };
            uplink = "isp-a";
          };
          upstream = {
            adapterName = "p2p-nixos-router-core-isp-a-nixos-router-upstream-upstream";
            attach = {
              bridge = "br-nixos-core-isp-a-upstream";
              kind = "bridge";
            };
            interface = {
              name = "upstream";
            };
            link = "p2p-nixos-router-core-isp-a-nixos-router-upstream";
          };
        };
      };
      esp-nixos-router-core-isp-b = withDeniedResolverNode {
        host = "s-router-nixos";
        logicalNode = {
          enterprise = "esp";
          name = "nixos-router-core-isp-b";
          site = "nixos";
        };
        platform = "nixos-container";
        ports = {
          isp-b = {
            attach = {
              bridge = "br-uplink1";
              kind = "bridge";
            };
            external = true;
            interface = {
              name = "isp-b";
            };
            uplink = "isp-b";
          };
          upstream = {
            adapterName = "p2p-nixos-router-core-isp-b-nixos-router-upstream-upstream";
            attach = {
              bridge = "br-nixos-core-isp-b-upstream";
              kind = "bridge";
            };
            interface = {
              name = "upstream";
            };
            link = "p2p-nixos-router-core-isp-b-nixos-router-upstream";
          };
        };
      };
      esp-nixos-router-core-nebula = withDeniedResolverNode {
        host = "s-router-nixos";
        logicalNode = {
          enterprise = "esp";
          name = "nixos-router-core-nebula";
          site = "nixos";
        };
        platform = "nixos-container";
        ports = {
          tenant-client = {
            attach = {
              bridge = "client";
              kind = "bridge";
            };
            interface = {
              name = "client";
            };
            logicalInterface = "tenant-client";
          };
          upstream = {
            adapterName = "p2p-nixos-router-core-nebula-nixos-router-upstream-upstream";
            attach = {
              bridge = "br-nixos-core-nebula-upstream";
              kind = "bridge";
            };
            interface = {
              name = "upstream";
            };
            link = "p2p-nixos-router-core-nebula-nixos-router-upstream";
          };
        };
      };
      esp-nixos-router-downstream = {
        host = "s-router-nixos";
        logicalNode = {
          enterprise = "esp";
          name = "nixos-router-downstream";
          site = "nixos";
        };
        platform = "nixos-container";
        ports = {
          access-admin = {
            adapterName = "p2p-nixos-router-access-admin-nixos-router-downstream-access-admin";
            attach = {
              bridge = "br-nixos-downstream-admin";
              kind = "bridge";
            };
            interface = {
              name = "access-admin";
            };
            link = "p2p-nixos-router-access-admin-nixos-router-downstream";
          };
          access-client = {
            adapterName = "p2p-nixos-router-access-client-nixos-router-downstream-access-client";
            attach = {
              bridge = "br-nixos-downstream-client";
              kind = "bridge";
            };
            interface = {
              name = "access-client";
            };
            link = "p2p-nixos-router-access-client-nixos-router-downstream";
          };
          access-dmz = {
            adapterName = "p2p-nixos-router-access-dmz-nixos-router-downstream-access-dmz";
            attach = {
              bridge = "br-nixos-downstream-dmz";
              kind = "bridge";
            };
            interface = {
              name = "access-dmz";
            };
            link = "p2p-nixos-router-access-dmz-nixos-router-downstream";
          };
          access-hostile = {
            adapterName = "p2p-nixos-router-access-hostile-nixos-router-downstream-access-hostile";
            attach = {
              bridge = "br-nixos-downstream-hostile";
              kind = "bridge";
            };
            interface = {
              name = "access-hostile";
            };
            link = "p2p-nixos-router-access-hostile-nixos-router-downstream";
          };
          access-mgmt = {
            adapterName = "p2p-nixos-router-access-mgmt-nixos-router-downstream-access-mgmt";
            attach = {
              bridge = "br-nixos-downstream-mgmt";
              kind = "bridge";
            };
            interface = {
              name = "access-mgmt";
            };
            link = "p2p-nixos-router-access-mgmt-nixos-router-downstream";
          };
          access-streaming = {
            adapterName = "p2p-nixos-router-access-streaming-nixos-router-downstream-access-streaming";
            attach = {
              bridge = "br-nixos-downstream-streaming";
              kind = "bridge";
            };
            interface = {
              name = "access-stream";
            };
            link = "p2p-nixos-router-access-streaming-nixos-router-downstream";
          };
          policy-admin = {
            adapterName = "p2p-nixos-router-downstream-nixos-router-policy--access-nixos-router-access-admin-policy-admin";
            attach = {
              bridge = "br-nixos-downstream-policy-access-admin";
              kind = "bridge";
            };
            interface = {
              name = "policy-admin";
            };
            link = "p2p-nixos-router-downstream-nixos-router-policy--access-nixos-router-access-admin";
          };
          policy-client = {
            adapterName = "p2p-nixos-router-downstream-nixos-router-policy--access-nixos-router-access-client-policy-client";
            attach = {
              bridge = "br-nixos-downstream-policy-access-client";
              kind = "bridge";
            };
            interface = {
              name = "policy-client";
            };
            link = "p2p-nixos-router-downstream-nixos-router-policy--access-nixos-router-access-client";
          };
          policy-dmz = {
            adapterName = "p2p-nixos-router-downstream-nixos-router-policy--access-nixos-router-access-dmz-policy-dmz";
            attach = {
              bridge = "br-nixos-downstream-policy-access-dmz";
              kind = "bridge";
            };
            interface = {
              name = "policy-dmz";
            };
            link = "p2p-nixos-router-downstream-nixos-router-policy--access-nixos-router-access-dmz";
          };
          policy-hostile = {
            adapterName = "p2p-nixos-router-downstream-nixos-router-policy--access-nixos-router-access-hostile-policy-hostile";
            attach = {
              bridge = "br-nixos-downstream-policy-access-hostile";
              kind = "bridge";
            };
            interface = {
              name = "policy-hostile";
            };
            link = "p2p-nixos-router-downstream-nixos-router-policy--access-nixos-router-access-hostile";
          };
          policy-mgmt = {
            adapterName = "p2p-nixos-router-downstream-nixos-router-policy--access-nixos-router-access-mgmt-policy-mgmt";
            attach = {
              bridge = "br-nixos-downstream-policy-access-mgmt";
              kind = "bridge";
            };
            interface = {
              name = "policy-mgmt";
            };
            link = "p2p-nixos-router-downstream-nixos-router-policy--access-nixos-router-access-mgmt";
          };
          policy-streaming = {
            adapterName = "p2p-nixos-router-downstream-nixos-router-policy--access-nixos-router-access-streaming-policy-streaming";
            attach = {
              bridge = "br-nixos-downstream-policy-access-streaming";
              kind = "bridge";
            };
            interface = {
              name = "policy-stream";
            };
            link = "p2p-nixos-router-downstream-nixos-router-policy--access-nixos-router-access-streaming";
          };
        };
      };
      esp-nixos-router-policy = {
        host = "s-router-nixos";
        logicalNode = {
          enterprise = "esp";
          name = "nixos-router-policy";
          site = "nixos";
        };
        platform = "nixos-container";
        ports = {
          downstream-admin = {
            adapterName = "p2p-nixos-router-downstream-nixos-router-policy--access-nixos-router-access-admin-downstream-admin";
            attach = {
              bridge = "br-nixos-downstream-policy-access-admin";
              kind = "bridge";
            };
            interface = {
              name = "down-admin";
            };
            link = "p2p-nixos-router-downstream-nixos-router-policy--access-nixos-router-access-admin";
          };
          downstream-client = {
            adapterName = "p2p-nixos-router-downstream-nixos-router-policy--access-nixos-router-access-client-downstream-client";
            attach = {
              bridge = "br-nixos-downstream-policy-access-client";
              kind = "bridge";
            };
            interface = {
              name = "down-client";
            };
            link = "p2p-nixos-router-downstream-nixos-router-policy--access-nixos-router-access-client";
          };
          downstream-dmz = {
            adapterName = "p2p-nixos-router-downstream-nixos-router-policy--access-nixos-router-access-dmz-downstream-dmz";
            attach = {
              bridge = "br-nixos-downstream-policy-access-dmz";
              kind = "bridge";
            };
            interface = {
              name = "downstream-dmz";
            };
            link = "p2p-nixos-router-downstream-nixos-router-policy--access-nixos-router-access-dmz";
          };
          downstream-hostile = {
            adapterName = "p2p-nixos-router-downstream-nixos-router-policy--access-nixos-router-access-hostile-downstream-hostile";
            attach = {
              bridge = "br-nixos-downstream-policy-access-hostile";
              kind = "bridge";
            };
            interface = {
              name = "down-hostile";
            };
            link = "p2p-nixos-router-downstream-nixos-router-policy--access-nixos-router-access-hostile";
          };
          downstream-mgmt = {
            adapterName = "p2p-nixos-router-downstream-nixos-router-policy--access-nixos-router-access-mgmt-downstream-mgmt";
            attach = {
              bridge = "br-nixos-downstream-policy-access-mgmt";
              kind = "bridge";
            };
            interface = {
              name = "downstream-mgmt";
            };
            link = "p2p-nixos-router-downstream-nixos-router-policy--access-nixos-router-access-mgmt";
          };
          downstream-streaming = {
            adapterName = "p2p-nixos-router-downstream-nixos-router-policy--access-nixos-router-access-streaming-downstream-streaming";
            attach = {
              bridge = "br-nixos-downstream-policy-access-streaming";
              kind = "bridge";
            };
            interface = {
              name = "downstr-stream";
            };
            link = "p2p-nixos-router-downstream-nixos-router-policy--access-nixos-router-access-streaming";
          };
          upstream-admin-isp-a = {
            adapterName = "p2p-nixos-router-policy-nixos-router-upstream--access-nixos-router-access-admin--uplink-isp-a-upstream-admin-isp-a";
            attach = {
              bridge = "br-nixos-policy-upstream-access-admin-isp-a";
              kind = "bridge";
            };
            interface = {
              name = "up-admin-a";
            };
            link = "p2p-nixos-router-policy-nixos-router-upstream--access-nixos-router-access-admin--uplink-isp-a";
          };
          upstream-admin-isp-b = {
            adapterName = "p2p-nixos-router-policy-nixos-router-upstream--access-nixos-router-access-admin--uplink-isp-b-upstream-admin-isp-b";
            attach = {
              bridge = "br-nixos-policy-upstream-access-admin-isp-b";
              kind = "bridge";
            };
            interface = {
              name = "up-admin-b";
            };
            link = "p2p-nixos-router-policy-nixos-router-upstream--access-nixos-router-access-admin--uplink-isp-b";
          };
          upstream-client-isp-a = {
            adapterName = "p2p-nixos-router-policy-nixos-router-upstream--access-nixos-router-access-client--uplink-isp-a-upstream-client-isp-a";
            attach = {
              bridge = "br-nixos-policy-upstream-access-client-isp-a";
              kind = "bridge";
            };
            interface = {
              name = "up-client-a";
            };
            link = "p2p-nixos-router-policy-nixos-router-upstream--access-nixos-router-access-client--uplink-isp-a";
          };
          upstream-client-isp-b = {
            adapterName = "p2p-nixos-router-policy-nixos-router-upstream--access-nixos-router-access-client--uplink-isp-b-upstream-client-isp-b";
            attach = {
              bridge = "br-nixos-policy-upstream-access-client-isp-b";
              kind = "bridge";
            };
            interface = {
              name = "up-client-b";
            };
            link = "p2p-nixos-router-policy-nixos-router-upstream--access-nixos-router-access-client--uplink-isp-b";
          };
          upstream-hostile-east-west = {
            adapterName = "p2p-nixos-router-policy-nixos-router-upstream--access-nixos-router-access-hostile--uplink-east-west-upstream-hostile-east-west";
            attach = {
              bridge = "br-nixos-policy-upstream-access-hostile-east-west";
              kind = "bridge";
            };
            interface = {
              name = "up-hostile-ew";
            };
            link = "p2p-nixos-router-policy-nixos-router-upstream--access-nixos-router-access-hostile--uplink-east-west";
          };
          upstream-mgmt-isp-a = {
            adapterName = "p2p-nixos-router-policy-nixos-router-upstream--access-nixos-router-access-mgmt--uplink-isp-a-upstream-mgmt-isp-a";
            attach = {
              bridge = "br-nixos-policy-upstream-access-mgmt-isp-a";
              kind = "bridge";
            };
            interface = {
              name = "up-mgmt-a";
            };
            link = "p2p-nixos-router-policy-nixos-router-upstream--access-nixos-router-access-mgmt--uplink-isp-a";
          };
          upstream-mgmt-isp-b = {
            adapterName = "p2p-nixos-router-policy-nixos-router-upstream--access-nixos-router-access-mgmt--uplink-isp-b-upstream-mgmt-isp-b";
            attach = {
              bridge = "br-nixos-policy-upstream-access-mgmt-isp-b";
              kind = "bridge";
            };
            interface = {
              name = "up-mgmt-b";
            };
            link = "p2p-nixos-router-policy-nixos-router-upstream--access-nixos-router-access-mgmt--uplink-isp-b";
          };
          upstream-streaming-isp-a = {
            adapterName = "p2p-nixos-router-policy-nixos-router-upstream--access-nixos-router-access-streaming--uplink-isp-a-upstream-streaming-isp-a";
            attach = {
              bridge = "br-nixos-policy-upstream-access-streaming-isp-a";
              kind = "bridge";
            };
            interface = {
              name = "up-stream-a";
            };
            link = "p2p-nixos-router-policy-nixos-router-upstream--access-nixos-router-access-streaming--uplink-isp-a";
          };
          upstream-streaming-isp-b = {
            adapterName = "p2p-nixos-router-policy-nixos-router-upstream--access-nixos-router-access-streaming--uplink-isp-b-upstream-streaming-isp-b";
            attach = {
              bridge = "br-nixos-policy-upstream-access-streaming-isp-b";
              kind = "bridge";
            };
            interface = {
              name = "up-stream-b";
            };
            link = "p2p-nixos-router-policy-nixos-router-upstream--access-nixos-router-access-streaming--uplink-isp-b";
          };
        };
      };
      esp-nixos-router-upstream = {
        host = "s-router-nixos";
        logicalNode = {
          enterprise = "esp";
          name = "nixos-router-upstream";
          site = "nixos";
        };
        platform = "nixos-container";
        ports = {
          core-isp-a = {
            adapterName = "p2p-nixos-router-core-isp-a-nixos-router-upstream-core-isp-a";
            attach = {
              bridge = "br-nixos-core-isp-a-upstream";
              kind = "bridge";
            };
            interface = {
              name = "core-a";
            };
            link = "p2p-nixos-router-core-isp-a-nixos-router-upstream";
          };
          core-isp-b = {
            adapterName = "p2p-nixos-router-core-isp-b-nixos-router-upstream-core-isp-b";
            attach = {
              bridge = "br-nixos-core-isp-b-upstream";
              kind = "bridge";
            };
            interface = {
              name = "core-b";
            };
            link = "p2p-nixos-router-core-isp-b-nixos-router-upstream";
          };
          core-nebula = {
            adapterName = "p2p-nixos-router-core-nebula-nixos-router-upstream-core-nebula";
            attach = {
              bridge = "br-nixos-core-nebula-upstream";
              kind = "bridge";
            };
            interface = {
              name = "core-nebula";
            };
            link = "p2p-nixos-router-core-nebula-nixos-router-upstream";
          };
          policy-admin-isp-a = {
            adapterName = "p2p-nixos-router-policy-nixos-router-upstream--access-nixos-router-access-admin--uplink-isp-a-policy-admin-isp-a";
            attach = {
              bridge = "br-nixos-policy-upstream-access-admin-isp-a";
              kind = "bridge";
            };
            interface = {
              name = "pol-admin-a";
            };
            link = "p2p-nixos-router-policy-nixos-router-upstream--access-nixos-router-access-admin--uplink-isp-a";
          };
          policy-admin-isp-b = {
            adapterName = "p2p-nixos-router-policy-nixos-router-upstream--access-nixos-router-access-admin--uplink-isp-b-policy-admin-isp-b";
            attach = {
              bridge = "br-nixos-policy-upstream-access-admin-isp-b";
              kind = "bridge";
            };
            interface = {
              name = "pol-admin-b";
            };
            link = "p2p-nixos-router-policy-nixos-router-upstream--access-nixos-router-access-admin--uplink-isp-b";
          };
          policy-client-isp-a = {
            adapterName = "p2p-nixos-router-policy-nixos-router-upstream--access-nixos-router-access-client--uplink-isp-a-policy-client-isp-a";
            attach = {
              bridge = "br-nixos-policy-upstream-access-client-isp-a";
              kind = "bridge";
            };
            interface = {
              name = "pol-client-a";
            };
            link = "p2p-nixos-router-policy-nixos-router-upstream--access-nixos-router-access-client--uplink-isp-a";
          };
          policy-client-isp-b = {
            adapterName = "p2p-nixos-router-policy-nixos-router-upstream--access-nixos-router-access-client--uplink-isp-b-policy-client-isp-b";
            attach = {
              bridge = "br-nixos-policy-upstream-access-client-isp-b";
              kind = "bridge";
            };
            interface = {
              name = "pol-client-b";
            };
            link = "p2p-nixos-router-policy-nixos-router-upstream--access-nixos-router-access-client--uplink-isp-b";
          };
          policy-hostile-east-west = {
            adapterName = "p2p-nixos-router-policy-nixos-router-upstream--access-nixos-router-access-hostile--uplink-east-west-policy-hostile-east-west";
            attach = {
              bridge = "br-nixos-policy-upstream-access-hostile-east-west";
              kind = "bridge";
            };
            interface = {
              name = "pol-hostile-ew";
            };
            link = "p2p-nixos-router-policy-nixos-router-upstream--access-nixos-router-access-hostile--uplink-east-west";
          };
          policy-mgmt-isp-a = {
            adapterName = "p2p-nixos-router-policy-nixos-router-upstream--access-nixos-router-access-mgmt--uplink-isp-a-policy-mgmt-isp-a";
            attach = {
              bridge = "br-nixos-policy-upstream-access-mgmt-isp-a";
              kind = "bridge";
            };
            interface = {
              name = "pol-mgmt-a";
            };
            link = "p2p-nixos-router-policy-nixos-router-upstream--access-nixos-router-access-mgmt--uplink-isp-a";
          };
          policy-mgmt-isp-b = {
            adapterName = "p2p-nixos-router-policy-nixos-router-upstream--access-nixos-router-access-mgmt--uplink-isp-b-policy-mgmt-isp-b";
            attach = {
              bridge = "br-nixos-policy-upstream-access-mgmt-isp-b";
              kind = "bridge";
            };
            interface = {
              name = "pol-mgmt-b";
            };
            link = "p2p-nixos-router-policy-nixos-router-upstream--access-nixos-router-access-mgmt--uplink-isp-b";
          };
          policy-streaming-isp-a = {
            adapterName = "p2p-nixos-router-policy-nixos-router-upstream--access-nixos-router-access-streaming--uplink-isp-a-policy-streaming-isp-a";
            attach = {
              bridge = "br-nixos-policy-upstream-access-streaming-isp-a";
              kind = "bridge";
            };
            interface = {
              name = "pol-stream-a";
            };
            link = "p2p-nixos-router-policy-nixos-router-upstream--access-nixos-router-access-streaming--uplink-isp-a";
          };
          policy-streaming-isp-b = {
            adapterName = "p2p-nixos-router-policy-nixos-router-upstream--access-nixos-router-access-streaming--uplink-isp-b-policy-streaming-isp-b";
            attach = {
              bridge = "br-nixos-policy-upstream-access-streaming-isp-b";
              kind = "bridge";
            };
            interface = {
              name = "pol-stream-b";
            };
            link = "p2p-nixos-router-policy-nixos-router-upstream--access-nixos-router-access-streaming--uplink-isp-b";
          };
        };
      };
      esp-hetz-router-access-client = {
        advertisements = {
          dhcp4 = {
            tenant-client = {
              dnsServers = [ "router-self" ];
              domain = "lan.";
            };
          };
          ipv6Ra = {
            tenant-client = {
              dnssl = [ "lan." ];
              rdnss = [ "router-self" ];
            };
          };
        };
        host = "s-router-hetzner-anywhere";
        logicalNode = {
          enterprise = "esp";
          name = "hetz-router-access-client";
          site = "hetz";
        };
        platform = "nixos-container";
        ports = {
          tenant-client = {
            attach = {
              bridge = "client";
              kind = "bridge";
            };
            interface = {
              name = "tenant-client";
            };
            logicalInterface = "tenant-client";
          };
          transit-downstream = {
            adapterName = "p2p-hetz-router-access-client-hetz-router-downstream-transit-downstream";
            attach = {
              bridge = "br-hetz-downstream-client";
              kind = "bridge";
            };
            interface = {
              name = "transit";
            };
            link = "p2p-hetz-router-access-client-hetz-router-downstream";
          };
        };
        services = {
          dns = withDeniedResolverCidrs {
            advertised = {
              dnsServers = [ "router-self" ];
              rdnss = [ "router-self" ];
            };
          };
        };
      };
      esp-hetz-router-access-dmz = {
        advertisements = {
          dhcp4 = {
            tenant-dmz = {
              dnsServers = [ "router-self" ];
              domain = "lan.";
            };
          };
          ipv6Ra = {
            tenant-dmz = {
              dnssl = [ "lan." ];
              rdnss = [ "router-self" ];
            };
          };
        };
        host = "s-router-hetzner-anywhere";
        logicalNode = {
          enterprise = "esp";
          name = "hetz-router-access-dmz";
          site = "hetz";
        };
        platform = "nixos-container";
        ports = {
          tenant-dmz = {
            attach = {
              bridge = "dmz";
              kind = "bridge";
            };
            interface = {
              name = "tenant-dmz";
            };
            logicalInterface = "tenant-dmz";
          };
          transit-downstream = {
            adapterName = "p2p-hetz-router-access-dmz-hetz-router-downstream-transit-downstream";
            attach = {
              bridge = "br-hetz-downstream-dmz";
              kind = "bridge";
            };
            interface = {
              name = "transit";
            };
            link = "p2p-hetz-router-access-dmz-hetz-router-downstream";
          };
        };
        services = {
          dns = withDeniedResolverCidrs {
            advertised = {
              dnsServers = [ "router-self" ];
              rdnss = [ "router-self" ];
            };
          };
        };
      };
      esp-hetz-router-core = withDeniedResolverNode {
        host = "s-router-hetzner-anywhere";
        logicalNode = {
          enterprise = "esp";
          name = "hetz-router-core";
          site = "hetz";
        };
        platform = "nixos-container";
        ports = {
          upstream = {
            adapterName = "p2p-hetz-router-core-hetz-router-upstream-upstream";
            attach = {
              bridge = "br-hetz-core-upstream";
              kind = "bridge";
            };
            interface = {
              name = "upstream";
            };
            link = "p2p-hetz-router-core-hetz-router-upstream";
          };
          wan = {
            attach = {
              bridge = "br-wan";
              kind = "bridge";
            };
            external = true;
            interface = {
              addr4 = "172.31.254.3/24";
              addr6 = "fd42:dead:cafe:ffff::3/64";
              name = "wan";
              routes = {
                ipv4 = [
                  {
                    prefix = "0.0.0.0/0";
                    via = "172.31.254.1";
                  }
                ];
                ipv6 = [
                  {
                    prefix = "::/0";
                    via = "fd42:dead:cafe:ffff::1";
                  }
                ];
              };
            };
            uplink = "wan";
          };
        };
      };
      esp-hetz-router-downstream = {
        host = "s-router-hetzner-anywhere";
        logicalNode = {
          enterprise = "esp";
          name = "hetz-router-downstream";
          site = "hetz";
        };
        platform = "nixos-container";
        ports = {
          access-client = {
            adapterName = "p2p-hetz-router-access-client-hetz-router-downstream-access-client";
            attach = {
              bridge = "br-hetz-downstream-client";
              kind = "bridge";
            };
            interface = {
              name = "access-client";
            };
            link = "p2p-hetz-router-access-client-hetz-router-downstream";
          };
          access-dmz = {
            adapterName = "p2p-hetz-router-access-dmz-hetz-router-downstream-access-dmz";
            attach = {
              bridge = "br-hetz-downstream-dmz";
              kind = "bridge";
            };
            interface = {
              name = "access-dmz";
            };
            link = "p2p-hetz-router-access-dmz-hetz-router-downstream";
          };
          policy-client = {
            adapterName = "p2p-hetz-router-downstream-hetz-router-policy--access-hetz-router-access-client-policy-client";
            attach = {
              bridge = "br-hetz-downstream-policy-access-client";
              kind = "bridge";
            };
            interface = {
              name = "policy-client";
            };
            link = "p2p-hetz-router-downstream-hetz-router-policy--access-hetz-router-access-client";
          };
          policy-dmz = {
            adapterName = "p2p-hetz-router-downstream-hetz-router-policy--access-hetz-router-access-dmz-policy-dmz";
            attach = {
              bridge = "br-hetz-downstream-policy-access-dmz";
              kind = "bridge";
            };
            interface = {
              name = "policy-dmz";
            };
            link = "p2p-hetz-router-downstream-hetz-router-policy--access-hetz-router-access-dmz";
          };
        };
      };
      esp-hetz-router-nebula-core = withDeniedResolverNode {
        host = "s-router-hetzner-anywhere";
        logicalNode = {
          enterprise = "esp";
          name = "hetz-router-nebula-core";
          site = "hetz";
        };
        platform = "nixos-container";
        ports = {
          tenant-client = {
            attach = {
              bridge = "client";
              kind = "bridge";
            };
            interface = {
              name = "client";
            };
            logicalInterface = "tenant-client";
          };
          east-west = {
            attach = {
              bridge = "br-wan";
              kind = "bridge";
            };
            external = true;
            interface = {
              addr4 = "172.31.254.2/24";
              name = "east-west";
              routes = {
                ipv4 = [
                  {
                    metric = 5000;
                    prefix = "0.0.0.0/0";
                    via = "172.31.254.1";
                  }
                ];
              };
            };
            uplink = "east-west";
          };
          upstream = {
            adapterName = "p2p-hetz-router-nebula-core-hetz-router-upstream-upstream";
            attach = {
              bridge = "br-hetz-nebula-core-upstream";
              kind = "bridge";
            };
            interface = {
              name = "upstream";
            };
            link = "p2p-hetz-router-nebula-core-hetz-router-upstream";
          };
        };
      };
      esp-hetz-router-policy = {
        host = "s-router-hetzner-anywhere";
        logicalNode = {
          enterprise = "esp";
          name = "hetz-router-policy";
          site = "hetz";
        };
        platform = "nixos-container";
        ports = {
          downstream-client = {
            adapterName = "p2p-hetz-router-downstream-hetz-router-policy--access-hetz-router-access-client-downstream-client";
            attach = {
              bridge = "br-hetz-downstream-policy-access-client";
              kind = "bridge";
            };
            interface = {
              name = "down-client";
            };
            link = "p2p-hetz-router-downstream-hetz-router-policy--access-hetz-router-access-client";
          };
          downstream-dmz = {
            adapterName = "p2p-hetz-router-downstream-hetz-router-policy--access-hetz-router-access-dmz-downstream-dmz";
            attach = {
              bridge = "br-hetz-downstream-policy-access-dmz";
              kind = "bridge";
            };
            interface = {
              name = "downstream-dmz";
            };
            link = "p2p-hetz-router-downstream-hetz-router-policy--access-hetz-router-access-dmz";
          };
          upstream-client-wan = {
            adapterName = "p2p-hetz-router-policy-hetz-router-upstream--access-hetz-router-access-client--uplink-wan-upstream-client-wan";
            attach = {
              bridge = "br-hetz-policy-upstream-access-client-wan";
              kind = "bridge";
            };
            interface = {
              name = "up-client-wan";
            };
            link = "p2p-hetz-router-policy-hetz-router-upstream--access-hetz-router-access-client--uplink-wan";
          };
          upstream-dmz-wan = {
            adapterName = "p2p-hetz-router-policy-hetz-router-upstream--access-hetz-router-access-dmz--uplink-wan-upstream-dmz-wan";
            attach = {
              bridge = "br-hetz-policy-upstream-access-dmz-wan";
              kind = "bridge";
            };
            interface = {
              name = "up-dmz-wan";
            };
            link = "p2p-hetz-router-policy-hetz-router-upstream--access-hetz-router-access-dmz--uplink-wan";
          };
          upstream-dmz-east-west = {
            adapterName = "p2p-hetz-router-policy-hetz-router-upstream--access-hetz-router-access-dmz--uplink-east-west-upstream-dmz-east-west";
            attach = {
              bridge = "br-hetz-policy-upstream-access-dmz-east-west";
              kind = "bridge";
            };
            interface = {
              name = "up-dmz-ew";
            };
            link = "p2p-hetz-router-policy-hetz-router-upstream--access-hetz-router-access-dmz--uplink-east-west";
          };
        };
      };
      esp-hetz-router-upstream = {
        host = "s-router-hetzner-anywhere";
        logicalNode = {
          enterprise = "esp";
          name = "hetz-router-upstream";
          site = "hetz";
        };
        platform = "nixos-container";
        ports = {
          core = {
            adapterName = "p2p-hetz-router-core-hetz-router-upstream-core";
            attach = {
              bridge = "br-hetz-core-upstream";
              kind = "bridge";
            };
            interface = {
              name = "core";
            };
            link = "p2p-hetz-router-core-hetz-router-upstream";
          };
          nebula-core = {
            adapterName = "p2p-hetz-router-nebula-core-hetz-router-upstream-nebula-core";
            attach = {
              bridge = "br-hetz-nebula-core-upstream";
              kind = "bridge";
            };
            interface = {
              name = "nebula-core";
            };
            link = "p2p-hetz-router-nebula-core-hetz-router-upstream";
          };
          policy-client-wan = {
            adapterName = "p2p-hetz-router-policy-hetz-router-upstream--access-hetz-router-access-client--uplink-wan-policy-client-wan";
            attach = {
              bridge = "br-hetz-policy-upstream-access-client-wan";
              kind = "bridge";
            };
            interface = {
              name = "pol-client-wan";
            };
            link = "p2p-hetz-router-policy-hetz-router-upstream--access-hetz-router-access-client--uplink-wan";
          };
          policy-dmz-wan = {
            adapterName = "p2p-hetz-router-policy-hetz-router-upstream--access-hetz-router-access-dmz--uplink-wan-policy-dmz-wan";
            attach = {
              bridge = "br-hetz-policy-upstream-access-dmz-wan";
              kind = "bridge";
            };
            interface = {
              name = "policy-dmz-wan";
            };
            link = "p2p-hetz-router-policy-hetz-router-upstream--access-hetz-router-access-dmz--uplink-wan";
          };
          policy-dmz-east-west = {
            adapterName = "p2p-hetz-router-policy-hetz-router-upstream--access-hetz-router-access-dmz--uplink-east-west-policy-dmz-east-west";
            attach = {
              bridge = "br-hetz-policy-upstream-access-dmz-east-west";
              kind = "bridge";
            };
            interface = {
              name = "pol-dmz-ew";
            };
            link = "p2p-hetz-router-policy-hetz-router-upstream--access-hetz-router-access-dmz--uplink-east-west";
          };
        };
      };
    }
    // clabAccessNodes
    // {
      esp-clab-router-core-nebula = withDeniedResolverNode {
        host = "s-router-clab";
        logicalNode = {
          enterprise = "esp";
          name = "clab-router-core-nebula";
          site = "clab";
        };
        platform = "nixos-container";
        ports = {
          tenant-client = {
            attach = {
              bridge = "client";
              kind = "bridge";
            };
            interface = {
              name = "client";
            };
            logicalInterface = "tenant-client";
          };
          upstream = {
            adapterName = "p2p-clab-router-core-nebula-clab-router-upstream-upstream";
            attach = {
              bridge = "br-clab-core-nebula-upstream";
              kind = "bridge";
            };
            interface = {
              name = "upstream";
            };
            link = "p2p-clab-router-core-nebula-clab-router-upstream";
          };
        };
      };
      esp-clab-router-core-simulated-isp = withDeniedResolverNode {
        host = "s-router-clab";
        logicalNode = {
          enterprise = "esp";
          name = "clab-router-core-simulated-isp";
          site = "clab";
        };
        platform = "nixos-container";
        ports = {
          upstream = {
            adapterName = "p2p-clab-router-core-simulated-isp-clab-router-upstream-upstream";
            attach = {
              bridge = "br-clab-core-simulated-isp-upstream";
              kind = "bridge";
            };
            interface = {
              name = "upstream";
            };
            link = "p2p-clab-router-core-simulated-isp-clab-router-upstream";
          };
          wan = {
            attach = {
              bridge = "br-uplink1";
              kind = "bridge";
            };
            external = true;
            interface = {
              name = "wan";
            };
            uplink = "wan";
          };
        };
      };
      esp-clab-router-downstream = {
        host = "s-router-clab";
        logicalNode = {
          enterprise = "esp";
          name = "clab-router-downstream";
          site = "clab";
        };
        platform = "nixos-container";
        ports = clabDownstreamAccessPorts // clabDownstreamPolicyPorts;
      };
      esp-clab-router-policy = {
        host = "s-router-clab";
        logicalNode = {
          enterprise = "esp";
          name = "clab-router-policy";
          site = "clab";
        };
        platform = "nixos-container";
        ports = clabPolicyDownstreamPorts // clabPolicyWanPorts // clabPolicyEastWestPorts;
      };
      esp-clab-router-upstream = {
        host = "s-router-clab";
        logicalNode = {
          enterprise = "esp";
          name = "clab-router-upstream";
          site = "clab";
        };
        platform = "nixos-container";
        ports = {
          core-simulated-isp = {
            adapterName = "p2p-clab-router-core-simulated-isp-clab-router-upstream-core-simulated-isp";
            attach = {
              bridge = "br-clab-core-simulated-isp-upstream";
              kind = "bridge";
            };
            interface = {
              name = "core-isp";
            };
            link = "p2p-clab-router-core-simulated-isp-clab-router-upstream";
          };
          core-nebula = {
            adapterName = "p2p-clab-router-core-nebula-clab-router-upstream-core-nebula";
            attach = {
              bridge = "br-clab-core-nebula-upstream";
              kind = "bridge";
            };
            interface = {
              name = "core-nebula";
            };
            link = "p2p-clab-router-core-nebula-clab-router-upstream";
          };
        }
        // clabUpstreamWanPorts
        // clabUpstreamEastWestPorts;
      };
    };
  };
}
