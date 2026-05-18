let
  clabAccessTenants = {
    admin = {
      ipv4Prefix = "10.50.15.0/24";
      ipv4Router = "10.50.15.1";
      ipv6Prefix = "fd42:dead:feed:15::/64";
      ipv6Router = "fd42:dead:feed:15::1";
    };
    client = {
      externalValidation = {
        delegatedIPv6Prefix = true;
      };
      ipv4Prefix = "10.50.20.0/24";
      ipv4Router = "10.50.20.1";
      ipv6Prefix = "fd42:dead:feed:20::/64";
      ipv6Router = "fd42:dead:feed:20::1";
    };
    dmz = {
      ipv4Prefix = "10.50.30.0/24";
      ipv4Router = "10.50.30.1";
      ipv6Prefix = "fd42:dead:feed:30::/64";
      ipv6Router = "fd42:dead:feed:30::1";
    };
    hostile = {
      externalValidation = {
        delegatedIPv6Prefix = true;
      };
      ipv4Prefix = "10.70.10.0/24";
      ipv4Router = "10.70.10.1";
      ipv6Prefix = "fd42:dead:feed:70::/64";
      ipv6Router = "fd42:dead:feed:70::1";
    };
    mgmt = {
      ipv4Prefix = "10.50.10.0/24";
      ipv4Router = "10.50.10.1";
      ipv6Prefix = "fd42:dead:feed:10::/64";
      ipv6Router = "fd42:dead:feed:10::1";
    };
    streaming = {
      ipv4Prefix = "10.50.50.0/24";
      ipv4Router = "10.50.50.1";
      ipv6Prefix = "fd42:dead:feed:50::/64";
      ipv6Router = "fd42:dead:feed:50::1";
    };
  };

  clabAccessNode =
    tenant: spec:
    {
      advertisements = {
        dhcp4."tenant-${tenant}" = {
          dnsServers = [ "router-self" ];
          domain = "lan.";
          id = tenant;
          interface = "tenant-${tenant}";
          pool = {
            end = builtins.replaceStrings [ ".0/24" ] [ ".200" ] spec.ipv4Prefix;
            start = builtins.replaceStrings [ ".0/24" ] [ ".100" ] spec.ipv4Prefix;
          };
          router = spec.ipv4Router;
          subnet = spec.ipv4Prefix;
        };
        ipv6Ra."tenant-${tenant}" = {
          dnssl = [ "lan." ];
          interface = "tenant-${tenant}";
          prefixes = [ spec.ipv6Prefix ];
          rdnss = [ "router-self" ];
        };
      };
      host = "s-router-clab";
      logicalNode = {
        enterprise = "esp";
        name = "lab-example-router-access-${tenant}";
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
            addr4 = "${spec.ipv4Router}/24";
            addr6 = "${spec.ipv6Router}/64";
            name = "tenant-${tenant}";
          };
          logicalInterface = "tenant-${tenant}";
        };
        transit-downstream = {
          adapterName = "p2p-lab-example-router-access-${tenant}-lab-example-router-downstream-transit-downstream";
          attach = {
            bridge = "br-clab-downstream-${tenant}";
            kind = "bridge";
          };
          interface = {
            name = "transit";
          };
          link = "p2p-lab-example-router-access-${tenant}-lab-example-router-downstream";
        };
      };
      services = {
        dns = {
          advertised = {
            dnsServers = [ "router-self" ];
            rdnss = [ "router-self" ];
          };
          allowFrom = [
            spec.ipv4Prefix
            spec.ipv6Prefix
          ];
          forwarders = [
            "10.20.10.1"
            "fd42:dead:beef:10::1"
          ];
          listen = [
            spec.ipv4Router
            spec.ipv6Router
          ];
        };
      };
    }
    // (spec.externalValidation or { });

  clabAccessNodes = builtins.listToAttrs (
    map (tenant: {
      name = "esp-lab-example-router-access-${tenant}";
      value = clabAccessNode tenant clabAccessTenants.${tenant};
    }) (builtins.attrNames clabAccessTenants)
  );

  clabAccessTenantNames = builtins.attrNames clabAccessTenants;
  clabWanTenants = [ "admin" "client" "dmz" "streaming" ];
  clabEastWestTenants = [ "hostile" ];

  clabDownstreamAccessPorts = builtins.listToAttrs (
    map (tenant: {
      name = "access-${tenant}";
      value = {
        adapterName = "p2p-lab-example-router-access-${tenant}-lab-example-router-downstream-access-${tenant}";
        attach = {
          bridge = "br-clab-downstream-${tenant}";
          kind = "bridge";
        };
        interface = {
          name = "access-${tenant}";
        };
        link = "p2p-lab-example-router-access-${tenant}-lab-example-router-downstream";
      };
    }) clabAccessTenantNames
  );

  clabDownstreamPolicyPorts = builtins.listToAttrs (
    map (tenant: {
      name = "policy-${tenant}";
      value = {
        adapterName = "p2p-lab-example-router-downstream-lab-example-router-policy--access-lab-example-router-access-${tenant}-policy-${tenant}";
        attach = {
          bridge = "br-clab-downstream-policy-access-${tenant}";
          kind = "bridge";
        };
        interface = {
          name = "policy-${tenant}";
        };
        link = "p2p-lab-example-router-downstream-lab-example-router-policy--access-lab-example-router-access-${tenant}";
      };
    }) clabAccessTenantNames
  );

  clabPolicyDownstreamPorts = builtins.listToAttrs (
    map (tenant: {
      name = "downstream-${tenant}";
      value = {
        adapterName = "p2p-lab-example-router-downstream-lab-example-router-policy--access-lab-example-router-access-${tenant}-downstream-${tenant}";
        attach = {
          bridge = "br-clab-downstream-policy-access-${tenant}";
          kind = "bridge";
        };
        interface = {
          name = "downstream-${tenant}";
        };
        link = "p2p-lab-example-router-downstream-lab-example-router-policy--access-lab-example-router-access-${tenant}";
      };
    }) clabAccessTenantNames
  );

  clabPolicyWanPorts = builtins.listToAttrs (
    map (tenant: {
      name = "upstream-${tenant}";
      value = {
        adapterName = "p2p-lab-example-router-policy-lab-example-router-upstream--access-lab-example-router-access-${tenant}--uplink-wan-upstream-${tenant}";
        attach = {
          bridge = "br-clab-policy-upstream-access-${tenant}";
          kind = "bridge";
        };
        interface = {
          name = "upstream-${tenant}";
        };
        link = "p2p-lab-example-router-policy-lab-example-router-upstream--access-lab-example-router-access-${tenant}--uplink-wan";
      };
    }) clabWanTenants
  );

  clabPolicyEastWestPorts = builtins.listToAttrs (
    map (tenant: {
      name = "upstream-${tenant}-east-west";
      value = {
        adapterName = "p2p-lab-example-router-policy-lab-example-router-upstream--access-lab-example-router-access-${tenant}--uplink-east-west-upstream-${tenant}-east-west";
        attach = {
          bridge = "br-clab-policy-upstream-access-${tenant}-east-west";
          kind = "bridge";
        };
        interface = {
          name = "up-${tenant}-ew";
        };
        link = "p2p-lab-example-router-policy-lab-example-router-upstream--access-lab-example-router-access-${tenant}--uplink-east-west";
      };
    }) clabEastWestTenants
  );

  clabUpstreamWanPorts = builtins.listToAttrs (
    map (tenant: {
      name = "policy-${tenant}";
      value = {
        adapterName = "p2p-lab-example-router-policy-lab-example-router-upstream--access-lab-example-router-access-${tenant}--uplink-wan-policy-${tenant}";
        attach = {
          bridge = "br-clab-policy-upstream-access-${tenant}";
          kind = "bridge";
        };
        interface = {
          name = "policy-${tenant}";
        };
        link = "p2p-lab-example-router-policy-lab-example-router-upstream--access-lab-example-router-access-${tenant}--uplink-wan";
      };
    }) clabWanTenants
  );

  clabUpstreamEastWestPorts = builtins.listToAttrs (
    map (tenant: {
      name = "policy-${tenant}-east-west";
      value = {
        adapterName = "p2p-lab-example-router-policy-lab-example-router-upstream--access-lab-example-router-access-${tenant}--uplink-east-west-policy-${tenant}-east-west";
        attach = {
          bridge = "br-clab-policy-upstream-access-${tenant}-east-west";
          kind = "bridge";
        };
        interface = {
          name = "pol-${tenant}-ew";
        };
        link = "p2p-lab-example-router-policy-lab-example-router-upstream--access-lab-example-router-access-${tenant}--uplink-east-west";
      };
    }) clabEastWestTenants
  );
in
{
  containerlab = {
    roles = {
      core = {
        forwarding = {
          disable_eth0 = false;
        };
        wan_firewall = {
          masquerade = {
            ipv4 = true;
            ipv6 = true;
            oifnames = [ "eth2" ];
          };
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
  controlPlane = {
    sites = {
      esp = {
        nixos = {
          overlays = {
            east-west = {
              nodes = {
                  edge-example-router-lighthouse = {
                    addr4 = "100.96.10.254/32";
                    addr6 = "fd42:dead:beef:ee::254/128";
                  };
                  home-example-router-core-nebula = {
                    addr4 = "100.96.10.1/32";
                    addr6 = "fd42:dead:beef:ee::1/128";
                  };
                }; nebula = {
                lighthouse = {
                  endpoint = "198.51.100.10";
                  endpointSourceFile = "/run/secrets/hetzner-lighthouse-public-ipv4";
                  endpoint6 = "2001:db8:51::10";
                  endpoint6SourceFile = "/run/secrets/hetzner-public-ipv6";
                  node = "edge-example-router-lighthouse";
                  port = 4242;
                };
                role = "core-client";
                runtimeNodes = {
                  home-example-router-core-nebula = {
                    unsafeRoutes = [
                      { route = "10.60.10.0/24"; via4 = "100.96.10.2"; install = true; }
                      { route = "10.70.10.0/24"; via4 = "100.96.10.2"; install = true; }
                      { route = "10.90.10.0/24"; via4 = "100.96.10.3"; install = true; }
                      { route = "10.90.20.0/24"; via4 = "100.96.10.3"; install = true; }
                      { route = "fd42:dead:cafe:10::/64"; via6 = "fd42:dead:beef:ee::3"; install = true; }
                      { route = "fd42:dead:cafe:20::/64"; via6 = "fd42:dead:beef:ee::3"; install = true; }
                      { route = "fd42:dead:feed:10::/64"; via6 = "fd42:dead:beef:ee::2"; install = true; }
                      { route = "fd42:dead:feed:70::/64"; via6 = "fd42:dead:beef:ee::2"; install = true; }
                    ];
                  };
                };
              };
              provider = "nebula";
              underlayEndpointSourceFiles = {
                ipv4 = [ "/run/secrets/hetzner-lighthouse-public-ipv4" "/run/secrets/hetzner-public-ipv4" ];
                ipv6 = [ "/run/secrets/hetzner-public-ipv6" ];
              };
              runtimeNodes = {
                home-example-router-core-nebula = {
                  container = {
                    profile = "core-router-nebula";
                    targetContainer = "home-example-router-core-nebula";
                  };
                  groups = [
                    "lab"
                    "core"
                  ];
                  service = {
                    interface = "nebula1";
                    name = "nebula-runtime";
                  };
                  relay = {
                    relays = [ "edge-example-router-nebula-core" ];
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
                  edge-example-router-lighthouse = {
                    addr4 = "100.96.10.254/32";
                    addr6 = "fd42:dead:beef:ee::254/128";
                  };
                  edge-example-router-nebula-core = {
                    addr4 = "100.96.10.3/32";
                    addr6 = "fd42:dead:beef:ee::3/128";
                  };
                }; nebula = {
                lighthouse = {
                  endpoint = "198.51.100.10";
                  endpointSourceFile = "/run/secrets/hetzner-lighthouse-public-ipv4";
                  endpoint6 = "2001:db8:51::10";
                  endpoint6SourceFile = "/run/secrets/hetzner-public-ipv6";
                  node = "edge-example-router-lighthouse";
                  port = 4242;
                };
                role = "core-client";
                runtimeNodes = {
                  edge-example-router-lighthouse = {
                    unsafeRoutes = [ ];
                  };
                  edge-example-router-nebula-core = {
                    unsafeRoutes = [
                      { route = "10.20.10.0/24"; via4 = "100.96.10.1"; install = true; }
                      { route = "10.20.15.0/24"; via4 = "100.96.10.1"; install = true; }
                      { route = "10.20.20.0/24"; via4 = "100.96.10.1"; install = true; }
                      { route = "10.20.30.0/24"; via4 = "100.96.10.1"; install = true; }
                      { route = "10.20.40.0/24"; via4 = "100.96.10.1"; install = true; }
                      { route = "10.20.50.0/24"; via4 = "100.96.10.1"; install = true; }
                      { route = "10.60.10.0/24"; via4 = "100.96.10.2"; install = true; }
                      { route = "10.70.10.0/24"; via4 = "100.96.10.2"; install = true; }
                      { route = "fd42:dead:beef:10::/64"; via6 = "fd42:dead:beef:ee::1"; install = true; }
                      { route = "fd42:dead:beef:15::/64"; via6 = "fd42:dead:beef:ee::1"; install = true; }
                      { route = "fd42:dead:beef:20::/64"; via6 = "fd42:dead:beef:ee::1"; install = true; }
                      { route = "fd42:dead:beef:30::/64"; via6 = "fd42:dead:beef:ee::1"; install = true; }
                      { route = "fd42:dead:beef:40::/64"; via6 = "fd42:dead:beef:ee::1"; install = true; }
                      { route = "fd42:dead:beef:50::/64"; via6 = "fd42:dead:beef:ee::1"; install = true; }
                      { route = "fd42:dead:feed:10::/64"; via6 = "fd42:dead:beef:ee::2"; install = true; }
                      { route = "fd42:dead:feed:70::/64"; via6 = "fd42:dead:beef:ee::2"; install = true; }
                      {
                        route = "fd42:dead:feed:70::/64";
                        via6 = "fd42:dead:beef:ee::2";
                        install = true;
                        routeSourceFile = "/run/secrets/access-node-ipv6-prefix-esp-lab-example-router-access-hostile";
                      }
                    ];
                  };
                };
              };
              provider = "nebula";
              underlayEndpointSourceFiles = {
                ipv4 = [ "/run/secrets/hetzner-lighthouse-public-ipv4" "/run/secrets/hetzner-public-ipv4" ];
                ipv6 = [ "/run/secrets/hetzner-public-ipv6" ];
              };
              runtimeNodes = {
                edge-example-router-lighthouse = {
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
                edge-example-router-nebula-core = {
                  container = {
                    host = "s-router-hetzner-anywhere";
                    profile = "core-router-nebula";
                    targetContainer = "edge-example-router-nebula-core";
                  };
                  groups = [
                    "lab"
                    "hetz"
                    "core"
                  ];
                  service = {
                    interface = "nebula1";
                    name = "nebula-runtime";
                  };
                  relay = {
                    amRelay = true;
                  };
                };
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
            client = {
            };
          };
        };
        clab = {
          overlays = {
            east-west = {
              nodes = {
                  lab-example-router-core-nebula = {
                    addr4 = "100.96.10.2/32";
                    addr6 = "fd42:dead:beef:ee::2/128";
                  };
                  branch-node01 = {
                    addr4 = "100.96.10.20/32";
                    addr6 = "fd42:dead:beef:ee::20/128";
                  };
                  edge-example-router-lighthouse = {
                    addr4 = "100.96.10.254/32";
                    addr6 = "fd42:dead:beef:ee::254/128";
                  };
                  hostile-node01 = {
                    addr4 = "100.96.10.30/32";
                    addr6 = "fd42:dead:beef:ee::30/128";
                  };
                }; nebula = {
                lighthouse = {
                  endpoint = "198.51.100.10";
                  endpointSourceFile = "/run/secrets/hetzner-lighthouse-public-ipv4";
                  endpoint6 = "2001:db8:51::10";
                  endpoint6SourceFile = "/run/secrets/hetzner-public-ipv6";
                  node = "edge-example-router-lighthouse";
                  port = 4242;
                };
                role = "core-client";
                runtimeNodes = {
                  lab-example-router-core-nebula = {
                    unsafeRoutes = [
                      { route = "0.0.0.0/1"; via4 = "100.96.10.3"; install = true; }
                      { route = "128.0.0.0/1"; via4 = "100.96.10.3"; install = true; }
                      { route = "10.20.10.0/24"; via4 = "100.96.10.1"; install = true; }
                      { route = "10.20.15.0/24"; via4 = "100.96.10.1"; install = true; }
                      { route = "10.20.20.0/24"; via4 = "100.96.10.1"; install = true; }
                      { route = "10.20.30.0/24"; via4 = "100.96.10.1"; install = true; }
                      { route = "10.20.40.0/24"; via4 = "100.96.10.1"; install = true; }
                      { route = "10.20.50.0/24"; via4 = "100.96.10.1"; install = true; }
                      { route = "10.90.10.0/24"; via4 = "100.96.10.3"; install = true; }
                      { route = "10.90.20.0/24"; via4 = "100.96.10.3"; install = true; }
                      { route = "::/1"; via6 = "fd42:dead:beef:ee::3"; install = true; }
                      { route = "8000::/1"; via6 = "fd42:dead:beef:ee::3"; install = true; }
                      { route = "fd42:dead:beef:10::/64"; via6 = "fd42:dead:beef:ee::1"; install = true; }
                      { route = "fd42:dead:beef:15::/64"; via6 = "fd42:dead:beef:ee::1"; install = true; }
                      { route = "fd42:dead:beef:20::/64"; via6 = "fd42:dead:beef:ee::1"; install = true; }
                      { route = "fd42:dead:beef:30::/64"; via6 = "fd42:dead:beef:ee::1"; install = true; }
                      { route = "fd42:dead:beef:40::/64"; via6 = "fd42:dead:beef:ee::1"; install = true; }
                      { route = "fd42:dead:beef:50::/64"; via6 = "fd42:dead:beef:ee::1"; install = true; }
                      { route = "fd42:dead:cafe:10::/64"; via6 = "fd42:dead:beef:ee::3"; install = true; }
                      { route = "fd42:dead:cafe:20::/64"; via6 = "fd42:dead:beef:ee::3"; install = true; }
                    ];
                  };
                };
              };
              provider = "nebula";
              underlayEndpointSourceFiles = {
                ipv4 = [ "/run/secrets/hetzner-lighthouse-public-ipv4" "/run/secrets/hetzner-public-ipv4" ];
                ipv6 = [ "/run/secrets/hetzner-public-ipv6" ];
              };
              runtimeNodes = {
                lab-example-router-core-nebula = {
                  container = {
                    profile = "core-router-nebula";
                    targetContainer = "lab-example-router-core-nebula";
                  };
                  groups = [
                    "lab"
                    "branch"
                    "core"
                  ];
                  service = {
                    interface = "nebula1";
                    name = "nebula-runtime";
                  };
                  relay = {
                    relays = [ "edge-example-router-nebula-core" ];
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
  deployment = {
    hosts = {
      s-router-hetzner-anywhere = {
        bridgeNetworks = {
          br-hetz-core-upstream = { };
          br-hetz-downstream-client = { };
          br-hetz-downstream-dmz = { };
          br-hetz-downstream-policy-access-client = { };
          br-hetz-downstream-policy-access-dmz = { };
          br-hetz-nebula-core-upstream = { };
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
            parent = "eth0";
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
          br-nixos-policy-upstream-access-dmz-isp-a = { };
          br-nixos-policy-upstream-access-dmz-isp-b = { };
          br-nixos-policy-upstream-access-hostile-east-west = { };
          br-nixos-policy-upstream-access-mgmt-isp-a = { };
          br-nixos-policy-upstream-access-mgmt-isp-b = { };
          br-nixos-policy-upstream-access-streaming-isp-a = { };
          br-nixos-policy-upstream-access-streaming-isp-b = { };
          br-hetz-core-upstream = { };
          br-hetz-downstream-mgmt = { };
          br-hetz-downstream-policy-access-mgmt = { };
          br-hetz-nebula-core-upstream = { };
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
      s-router-clab = {
        bridgeNetworks = {
          admin = {
            mode = "vlan";
            parent = "eth0";
            vlan = 301;
          };
          br-clab-core-nebula-upstream = { };
          br-clab-core-simulated-isp-upstream = { };
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
  endpoints = {
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
    edge-example-router-lighthouse = {
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
  realization = {
    nodes = {
      esp-home-example-router-access-admin = {
        advertisements = {
          dhcp4 = {
            tenant-admin = {
              dnsServers = [ "router-self" ];
              domain = "lan.";
              id = "admin";
              interface = "tenant-admin";
              pool = {
                end = "10.20.15.200";
                start = "10.20.15.100";
              };
              router = "10.20.15.1";
              subnet = "10.20.15.0/24";
            };
          };
          ipv6Ra = {
            tenant-admin = {
              dnssl = [ "lan." ];
              interface = "tenant-admin";
              prefixes = [ "fd42:dead:beef:15::/64" ];
              rdnss = [ "router-self" ];
            };
          };
        };
        host = "s-router-test";
        logicalNode = {
          enterprise = "esp";
          name = "home-example-router-access-admin";
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
              addr4 = "10.20.15.1/24";
              addr6 = "fd42:dead:beef:15::1/64";
              name = "tenant-admin";
            };
            logicalInterface = "tenant-admin";
          };
          transit-downstream = {
            adapterName = "p2p-home-example-router-access-admin-home-example-router-downstream-transit-downstream";
            attach = {
              bridge = "br-nixos-downstream-admin";
              kind = "bridge";
            };
            interface = {
              name = "transit";
            };
            link = "p2p-home-example-router-access-admin-home-example-router-downstream";
          };
        };
        services = {
          dns = {
            allowFrom = [
              "10.20.15.0/24"
              "fd42:dead:beef:15::/64"
            ];
            forwarders = [
              "10.20.10.1"
              "fd42:dead:beef:10::1"
            ];
            listen = [
              "10.20.15.1"
              "fd42:dead:beef:15::1"
            ];
          };
        };
      };
      esp-home-example-router-access-client = {
        advertisements = {
          dhcp4 = {
            tenant-client = {
              dnsServers = [ "router-self" ];
              domain = "lan.";
              id = "client";
              interface = "tenant-client";
              pool = {
                end = "10.20.20.200";
                start = "10.20.20.100";
              };
              router = "10.20.20.1";
              subnet = "10.20.20.0/24";
            };
          };
          ipv6Ra = {
            tenant-client = {
              dnssl = [ "lan." ];
              interface = "tenant-client";
              prefixes = [ "fd42:dead:beef:20::/64" ];
              rdnss = [ "router-self" ];
            };
          };
        };
        host = "s-router-test";
        logicalNode = {
          enterprise = "esp";
          name = "home-example-router-access-client";
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
              addr4 = "10.20.20.1/24";
              addr6 = "fd42:dead:beef:20::1/64";
              name = "tenant-client";
            };
            logicalInterface = "tenant-client";
          };
          transit-downstream = {
            adapterName = "p2p-home-example-router-access-client-home-example-router-downstream-transit-downstream";
            attach = {
              bridge = "br-nixos-downstream-client";
              kind = "bridge";
            };
            interface = {
              name = "transit";
            };
            link = "p2p-home-example-router-access-client-home-example-router-downstream";
          };
        };
        services = {
          dns = {
            allowFrom = [
              "10.20.20.0/24"
              "fd42:dead:beef:20::/64"
            ];
            forwarders = [
              "10.20.10.1"
              "fd42:dead:beef:10::1"
            ];
            listen = [
              "10.20.20.1"
              "fd42:dead:beef:20::1"
            ];
          };
        };
      };
      esp-home-example-router-access-dmz = {
        advertisements = {
          dhcp4 = {
            tenant-dmz = {
              dnsServers = [ "router-self" ];
              domain = "lan.";
              id = "dmz";
              interface = "tenant-dmz";
              pool = {
                end = "10.20.30.200";
                start = "10.20.30.100";
              };
              router = "10.20.30.1";
              subnet = "10.20.30.0/24";
            };
          };
          ipv6Ra = {
            tenant-dmz = {
              dnssl = [ "lan." ];
              interface = "tenant-dmz";
              prefixes = [ "fd42:dead:beef:30::/64" ];
              rdnss = [ "router-self" ];
            };
          };
        };
        host = "s-router-test";
        logicalNode = {
          enterprise = "esp";
          name = "home-example-router-access-dmz";
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
              addr4 = "10.20.30.1/24";
              addr6 = "fd42:dead:beef:30::1/64";
              name = "tenant-dmz";
            };
            logicalInterface = "tenant-dmz";
          };
          transit-downstream = {
            adapterName = "p2p-home-example-router-access-dmz-home-example-router-downstream-transit-downstream";
            attach = {
              bridge = "br-nixos-downstream-dmz";
              kind = "bridge";
            };
            interface = {
              name = "transit";
            };
            link = "p2p-home-example-router-access-dmz-home-example-router-downstream";
          };
        };
        services = {
          dns = {
            advertised = {
              dnsServers = [ "router-self" ];
              rdnss = [ "router-self" ];
            };
            allowFrom = [
              "10.20.30.0/24"
              "fd42:dead:beef:30::/64"
            ];
            forwarders = [
              "10.20.10.1"
              "fd42:dead:beef:10::1"
            ];
            listen = [
              "10.20.30.1"
              "fd42:dead:beef:30::1"
            ];
          };
        };
      };
      esp-home-example-router-access-hostile = {
        advertisements = {
          dhcp4 = {
            tenant-hostile = {
              dnsServers = [ "router-self" ];
              domain = "lan.";
              id = "hostile";
              interface = "tenant-hostile";
              pool = {
                end = "10.20.70.200";
                start = "10.20.70.100";
              };
              router = "10.20.70.1";
              subnet = "10.20.70.0/24";
            };
          };
          ipv6Ra = {
            tenant-hostile = {
              dnssl = [ "lan." ];
              interface = "tenant-hostile";
              prefixes = [ "fd42:dead:beef:70::/64" ];
              rdnss = [ "router-self" ];
            };
          };
        };
        externalValidation = {
          delegatedIPv6Prefix = true;
        };
        host = "s-router-test";
        logicalNode = {
          enterprise = "esp";
          name = "home-example-router-access-hostile";
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
              addr4 = "10.20.70.1/24";
              addr6 = "fd42:dead:beef:70::1/64";
              name = "tenant-hostile";
            };
            logicalInterface = "tenant-hostile";
          };
          transit-downstream = {
            adapterName = "p2p-home-example-router-access-hostile-home-example-router-downstream-transit-downstream";
            attach = {
              bridge = "br-nixos-downstream-hostile";
              kind = "bridge";
            };
            interface = {
              name = "transit";
            };
            link = "p2p-home-example-router-access-hostile-home-example-router-downstream";
          };
        };
        services = {
          dns = {
            allowFrom = [
              "10.20.70.0/24"
              "fd42:dead:beef:70::/64"
            ];
            forwarders = [
              "1.1.1.1"
              "1.0.0.1"
              "2606:4700:4700::1111"
              "2606:4700:4700::1001"
            ];
            listen = [
              "10.20.70.1"
              "fd42:dead:beef:70::1"
            ];
          };
        };
      };
      esp-home-example-router-access-mgmt = {
        advertisements = {
          dhcp4 = {
            tenant-mgmt = {
              dnsServers = [ "router-self" ];
              domain = "lan.";
              id = "mgmt";
              interface = "tenant-mgmt";
              pool = {
                end = "10.20.10.200";
                start = "10.20.10.100";
              };
              router = "10.20.10.1";
              subnet = "10.20.10.0/24";
            };
          };
          ipv6Ra = {
            tenant-mgmt = {
              dnssl = [ "lan." ];
              interface = "tenant-mgmt";
              prefixes = [ "fd42:dead:beef:10::/64" ];
              rdnss = [ "router-self" ];
            };
          };
        };
        host = "s-router-test";
        logicalNode = {
          enterprise = "esp";
          name = "home-example-router-access-mgmt";
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
              addr4 = "10.20.10.1/24";
              addr6 = "fd42:dead:beef:10::1/64";
              name = "tenant-mgmt";
            };
            logicalInterface = "tenant-mgmt";
          };
          transit-downstream = {
            adapterName = "p2p-home-example-router-access-mgmt-home-example-router-downstream-transit-downstream";
            attach = {
              bridge = "br-nixos-downstream-mgmt";
              kind = "bridge";
            };
            interface = {
              name = "transit";
            };
            link = "p2p-home-example-router-access-mgmt-home-example-router-downstream";
          };
        };
        services = {
          dns = {
            allowFrom = [
              "10.20.10.0/24"
              "fd42:dead:beef:10::/64"
            ];
            forwarders = [
              "1.1.1.1"
              "1.0.0.1"
              "2606:4700:4700::1111"
              "2606:4700:4700::1001"
            ];
            listen = [
              "10.20.10.1"
              "fd42:dead:beef:10::1"
            ];
          };
        };
      };
      esp-home-example-router-access-streaming = {
        advertisements = {
          dhcp4 = {
            tenant-streaming = {
              dnsServers = [ "router-self" ];
              domain = "lan.";
              id = "streaming";
              interface = "tenant-streaming";
              pool = {
                end = "10.20.50.200";
                start = "10.20.50.100";
              };
              router = "10.20.50.1";
              subnet = "10.20.50.0/24";
            };
          };
          ipv6Ra = {
            tenant-streaming = {
              dnssl = [ "lan." ];
              interface = "tenant-streaming";
              prefixes = [ "fd42:dead:beef:50::/64" ];
              rdnss = [ "router-self" ];
            };
          };
        };
        host = "s-router-test";
        logicalNode = {
          enterprise = "esp";
          name = "home-example-router-access-streaming";
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
              addr4 = "10.20.50.1/24";
              addr6 = "fd42:dead:beef:50::1/64";
              name = "tenant-streaming";
            };
            logicalInterface = "tenant-streaming";
          };
          transit-downstream = {
            adapterName = "p2p-home-example-router-access-streaming-home-example-router-downstream-transit-downstream";
            attach = {
              bridge = "br-nixos-downstream-streaming";
              kind = "bridge";
            };
            interface = {
              name = "transit";
            };
            link = "p2p-home-example-router-access-streaming-home-example-router-downstream";
          };
        };
        services = {
          dns = {
            allowFrom = [
              "10.20.50.0/24"
              "fd42:dead:beef:50::/64"
            ];
            forwarders = [
              "10.20.10.1"
              "fd42:dead:beef:10::1"
            ];
            listen = [
              "10.20.50.1"
              "fd42:dead:beef:50::1"
            ];
          };
        };
      };
      esp-home-example-router-core-isp-a = {
        host = "s-router-test";
        logicalNode = {
          enterprise = "esp";
          name = "home-example-router-core-isp-a";
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
            };
            uplink = "isp-a";
          };
          upstream = {
            adapterName = "p2p-home-example-router-core-isp-a-home-example-router-upstream-upstream";
            attach = {
              bridge = "br-nixos-core-isp-a-upstream";
              kind = "bridge";
            };
            interface = {
              name = "upstream";
            };
            link = "p2p-home-example-router-core-isp-a-home-example-router-upstream";
          };
        };
      };
      esp-home-example-router-core-isp-b = {
        host = "s-router-test";
        logicalNode = {
          enterprise = "esp";
          name = "home-example-router-core-isp-b";
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
            adapterName = "p2p-home-example-router-core-isp-b-home-example-router-upstream-upstream";
            attach = {
              bridge = "br-nixos-core-isp-b-upstream";
              kind = "bridge";
            };
            interface = {
              name = "upstream";
            };
            link = "p2p-home-example-router-core-isp-b-home-example-router-upstream";
          };
        };
      };
      esp-home-example-router-core-nebula = {
        host = "s-router-test";
        logicalNode = {
          enterprise = "esp";
          name = "home-example-router-core-nebula";
          site = "nixos";
        };
        platform = "nixos-container";
        ports = {
          east-west = {
            attach = {
              bridge = "br-uplink1";
              kind = "bridge";
            };
            external = true;
            interface = {
              name = "east-west";
            };
            uplink = "east-west";
          };
          upstream = {
            adapterName = "p2p-home-example-router-core-nebula-home-example-router-upstream-upstream";
            attach = {
              bridge = "br-nixos-core-nebula-upstream";
              kind = "bridge";
            };
            interface = {
              name = "upstream";
            };
            link = "p2p-home-example-router-core-nebula-home-example-router-upstream";
          };
        };
      };
      esp-home-example-router-downstream = {
        host = "s-router-test";
        logicalNode = {
          enterprise = "esp";
          name = "home-example-router-downstream";
          site = "nixos";
        };
        platform = "nixos-container";
        ports = {
          access-admin = {
            adapterName = "p2p-home-example-router-access-admin-home-example-router-downstream-access-admin";
            attach = {
              bridge = "br-nixos-downstream-admin";
              kind = "bridge";
            };
            interface = {
              name = "access-admin";
            };
            link = "p2p-home-example-router-access-admin-home-example-router-downstream";
          };
          access-client = {
            adapterName = "p2p-home-example-router-access-client-home-example-router-downstream-access-client";
            attach = {
              bridge = "br-nixos-downstream-client";
              kind = "bridge";
            };
            interface = {
              name = "access-client";
            };
            link = "p2p-home-example-router-access-client-home-example-router-downstream";
          };
          access-dmz = {
            adapterName = "p2p-home-example-router-access-dmz-home-example-router-downstream-access-dmz";
            attach = {
              bridge = "br-nixos-downstream-dmz";
              kind = "bridge";
            };
            interface = {
              name = "access-dmz";
            };
            link = "p2p-home-example-router-access-dmz-home-example-router-downstream";
          };
          access-hostile = {
            adapterName = "p2p-home-example-router-access-hostile-home-example-router-downstream-access-hostile";
            attach = {
              bridge = "br-nixos-downstream-hostile";
              kind = "bridge";
            };
            interface = {
              name = "access-hostile";
            };
            link = "p2p-home-example-router-access-hostile-home-example-router-downstream";
          };
          access-mgmt = {
            adapterName = "p2p-home-example-router-access-mgmt-home-example-router-downstream-access-mgmt";
            attach = {
              bridge = "br-nixos-downstream-mgmt";
              kind = "bridge";
            };
            interface = {
              name = "access-mgmt";
            };
            link = "p2p-home-example-router-access-mgmt-home-example-router-downstream";
          };
          access-streaming = {
            adapterName = "p2p-home-example-router-access-streaming-home-example-router-downstream-access-streaming";
            attach = {
              bridge = "br-nixos-downstream-streaming";
              kind = "bridge";
            };
            interface = {
              name = "access-stream";
            };
            link = "p2p-home-example-router-access-streaming-home-example-router-downstream";
          };
          policy-admin = {
            adapterName = "p2p-home-example-router-downstream-home-example-router-policy--access-home-example-router-access-admin-policy-admin";
            attach = {
              bridge = "br-nixos-downstream-policy-access-admin";
              kind = "bridge";
            };
            interface = {
              name = "policy-admin";
            };
            link = "p2p-home-example-router-downstream-home-example-router-policy--access-home-example-router-access-admin";
          };
          policy-client = {
            adapterName = "p2p-home-example-router-downstream-home-example-router-policy--access-home-example-router-access-client-policy-client";
            attach = {
              bridge = "br-nixos-downstream-policy-access-client";
              kind = "bridge";
            };
            interface = {
              name = "policy-client";
            };
            link = "p2p-home-example-router-downstream-home-example-router-policy--access-home-example-router-access-client";
          };
          policy-dmz = {
            adapterName = "p2p-home-example-router-downstream-home-example-router-policy--access-home-example-router-access-dmz-policy-dmz";
            attach = {
              bridge = "br-nixos-downstream-policy-access-dmz";
              kind = "bridge";
            };
            interface = {
              name = "policy-dmz";
            };
            link = "p2p-home-example-router-downstream-home-example-router-policy--access-home-example-router-access-dmz";
          };
          policy-hostile = {
            adapterName = "p2p-home-example-router-downstream-home-example-router-policy--access-home-example-router-access-hostile-policy-hostile";
            attach = {
              bridge = "br-nixos-downstream-policy-access-hostile";
              kind = "bridge";
            };
            interface = {
              name = "policy-hostile";
            };
            link = "p2p-home-example-router-downstream-home-example-router-policy--access-home-example-router-access-hostile";
          };
          policy-mgmt = {
            adapterName = "p2p-home-example-router-downstream-home-example-router-policy--access-home-example-router-access-mgmt-policy-mgmt";
            attach = {
              bridge = "br-nixos-downstream-policy-access-mgmt";
              kind = "bridge";
            };
            interface = {
              name = "policy-mgmt";
            };
            link = "p2p-home-example-router-downstream-home-example-router-policy--access-home-example-router-access-mgmt";
          };
          policy-streaming = {
            adapterName = "p2p-home-example-router-downstream-home-example-router-policy--access-home-example-router-access-streaming-policy-streaming";
            attach = {
              bridge = "br-nixos-downstream-policy-access-streaming";
              kind = "bridge";
            };
            interface = {
              name = "policy-stream";
            };
            link = "p2p-home-example-router-downstream-home-example-router-policy--access-home-example-router-access-streaming";
          };
        };
      };
      esp-home-example-router-policy = {
        host = "s-router-test";
        logicalNode = {
          enterprise = "esp";
          name = "home-example-router-policy";
          site = "nixos";
        };
        platform = "nixos-container";
        ports = {
          downstream-admin = {
            adapterName = "p2p-home-example-router-downstream-home-example-router-policy--access-home-example-router-access-admin-downstream-admin";
            attach = {
              bridge = "br-nixos-downstream-policy-access-admin";
              kind = "bridge";
            };
            interface = {
              name = "downstream-admin";
            };
            link = "p2p-home-example-router-downstream-home-example-router-policy--access-home-example-router-access-admin";
          };
          downstream-client = {
            adapterName = "p2p-home-example-router-downstream-home-example-router-policy--access-home-example-router-access-client-downstream-client";
            attach = {
              bridge = "br-nixos-downstream-policy-access-client";
              kind = "bridge";
            };
            interface = {
              name = "downstream-client";
            };
            link = "p2p-home-example-router-downstream-home-example-router-policy--access-home-example-router-access-client";
          };
          downstream-dmz = {
            adapterName = "p2p-home-example-router-downstream-home-example-router-policy--access-home-example-router-access-dmz-downstream-dmz";
            attach = {
              bridge = "br-nixos-downstream-policy-access-dmz";
              kind = "bridge";
            };
            interface = {
              name = "downstream-dmz";
            };
            link = "p2p-home-example-router-downstream-home-example-router-policy--access-home-example-router-access-dmz";
          };
          downstream-hostile = {
            adapterName = "p2p-home-example-router-downstream-home-example-router-policy--access-home-example-router-access-hostile-downstream-hostile";
            attach = {
              bridge = "br-nixos-downstream-policy-access-hostile";
              kind = "bridge";
            };
            interface = {
              name = "downstream-hostile";
            };
            link = "p2p-home-example-router-downstream-home-example-router-policy--access-home-example-router-access-hostile";
          };
          downstream-mgmt = {
            adapterName = "p2p-home-example-router-downstream-home-example-router-policy--access-home-example-router-access-mgmt-downstream-mgmt";
            attach = {
              bridge = "br-nixos-downstream-policy-access-mgmt";
              kind = "bridge";
            };
            interface = {
              name = "downstream-mgmt";
            };
            link = "p2p-home-example-router-downstream-home-example-router-policy--access-home-example-router-access-mgmt";
          };
          downstream-streaming = {
            adapterName = "p2p-home-example-router-downstream-home-example-router-policy--access-home-example-router-access-streaming-downstream-streaming";
            attach = {
              bridge = "br-nixos-downstream-policy-access-streaming";
              kind = "bridge";
            };
            interface = {
              name = "downstr-stream";
            };
            link = "p2p-home-example-router-downstream-home-example-router-policy--access-home-example-router-access-streaming";
          };
          upstream-admin-isp-a = {
            adapterName = "p2p-home-example-router-policy-home-example-router-upstream--access-home-example-router-access-admin--uplink-isp-a-upstream-admin-isp-a";
            attach = {
              bridge = "br-nixos-policy-upstream-access-admin-isp-a";
              kind = "bridge";
            };
            interface = {
              name = "up-admin-a";
            };
            link = "p2p-home-example-router-policy-home-example-router-upstream--access-home-example-router-access-admin--uplink-isp-a";
          };
          upstream-admin-isp-b = {
            adapterName = "p2p-home-example-router-policy-home-example-router-upstream--access-home-example-router-access-admin--uplink-isp-b-upstream-admin-isp-b";
            attach = {
              bridge = "br-nixos-policy-upstream-access-admin-isp-b";
              kind = "bridge";
            };
            interface = {
              name = "up-admin-b";
            };
            link = "p2p-home-example-router-policy-home-example-router-upstream--access-home-example-router-access-admin--uplink-isp-b";
          };
          upstream-client-isp-a = {
            adapterName = "p2p-home-example-router-policy-home-example-router-upstream--access-home-example-router-access-client--uplink-isp-a-upstream-client-isp-a";
            attach = {
              bridge = "br-nixos-policy-upstream-access-client-isp-a";
              kind = "bridge";
            };
            interface = {
              name = "up-client-a";
            };
            link = "p2p-home-example-router-policy-home-example-router-upstream--access-home-example-router-access-client--uplink-isp-a";
          };
          upstream-client-isp-b = {
            adapterName = "p2p-home-example-router-policy-home-example-router-upstream--access-home-example-router-access-client--uplink-isp-b-upstream-client-isp-b";
            attach = {
              bridge = "br-nixos-policy-upstream-access-client-isp-b";
              kind = "bridge";
            };
            interface = {
              name = "up-client-b";
            };
            link = "p2p-home-example-router-policy-home-example-router-upstream--access-home-example-router-access-client--uplink-isp-b";
          };
          upstream-dmz-isp-a = {
            adapterName = "p2p-home-example-router-policy-home-example-router-upstream--access-home-example-router-access-dmz--uplink-isp-a-upstream-dmz-isp-a";
            attach = {
              bridge = "br-nixos-policy-upstream-access-dmz-isp-a";
              kind = "bridge";
            };
            interface = {
              name = "up-dmz-a";
            };
            link = "p2p-home-example-router-policy-home-example-router-upstream--access-home-example-router-access-dmz--uplink-isp-a";
          };
          upstream-dmz-isp-b = {
            adapterName = "p2p-home-example-router-policy-home-example-router-upstream--access-home-example-router-access-dmz--uplink-isp-b-upstream-dmz-isp-b";
            attach = {
              bridge = "br-nixos-policy-upstream-access-dmz-isp-b";
              kind = "bridge";
            };
            interface = {
              name = "up-dmz-b";
            };
            link = "p2p-home-example-router-policy-home-example-router-upstream--access-home-example-router-access-dmz--uplink-isp-b";
          };
          upstream-hostile-east-west = {
            adapterName = "p2p-home-example-router-policy-home-example-router-upstream--access-home-example-router-access-hostile--uplink-east-west-upstream-hostile-east-west";
            attach = {
              bridge = "br-nixos-policy-upstream-access-hostile-east-west";
              kind = "bridge";
            };
            interface = {
              name = "up-hostile-ew";
            };
            link = "p2p-home-example-router-policy-home-example-router-upstream--access-home-example-router-access-hostile--uplink-east-west";
          };
          upstream-mgmt-isp-a = {
            adapterName = "p2p-home-example-router-policy-home-example-router-upstream--access-home-example-router-access-mgmt--uplink-isp-a-upstream-mgmt-isp-a";
            attach = {
              bridge = "br-nixos-policy-upstream-access-mgmt-isp-a";
              kind = "bridge";
            };
            interface = {
              name = "up-mgmt-a";
            };
            link = "p2p-home-example-router-policy-home-example-router-upstream--access-home-example-router-access-mgmt--uplink-isp-a";
          };
          upstream-mgmt-isp-b = {
            adapterName = "p2p-home-example-router-policy-home-example-router-upstream--access-home-example-router-access-mgmt--uplink-isp-b-upstream-mgmt-isp-b";
            attach = {
              bridge = "br-nixos-policy-upstream-access-mgmt-isp-b";
              kind = "bridge";
            };
            interface = {
              name = "up-mgmt-b";
            };
            link = "p2p-home-example-router-policy-home-example-router-upstream--access-home-example-router-access-mgmt--uplink-isp-b";
          };
          upstream-streaming-isp-a = {
            adapterName = "p2p-home-example-router-policy-home-example-router-upstream--access-home-example-router-access-streaming--uplink-isp-a-upstream-streaming-isp-a";
            attach = {
              bridge = "br-nixos-policy-upstream-access-streaming-isp-a";
              kind = "bridge";
            };
            interface = {
              name = "up-stream-a";
            };
            link = "p2p-home-example-router-policy-home-example-router-upstream--access-home-example-router-access-streaming--uplink-isp-a";
          };
          upstream-streaming-isp-b = {
            adapterName = "p2p-home-example-router-policy-home-example-router-upstream--access-home-example-router-access-streaming--uplink-isp-b-upstream-streaming-isp-b";
            attach = {
              bridge = "br-nixos-policy-upstream-access-streaming-isp-b";
              kind = "bridge";
            };
            interface = {
              name = "up-stream-b";
            };
            link = "p2p-home-example-router-policy-home-example-router-upstream--access-home-example-router-access-streaming--uplink-isp-b";
          };
        };
      };
      esp-home-example-router-upstream = {
        host = "s-router-test";
        logicalNode = {
          enterprise = "esp";
          name = "home-example-router-upstream";
          site = "nixos";
        };
        platform = "nixos-container";
        ports = {
          core-isp-a = {
            adapterName = "p2p-home-example-router-core-isp-a-home-example-router-upstream-core-isp-a";
            attach = {
              bridge = "br-nixos-core-isp-a-upstream";
              kind = "bridge";
            };
            interface = {
              name = "core-a";
            };
            link = "p2p-home-example-router-core-isp-a-home-example-router-upstream";
          };
          core-isp-b = {
            adapterName = "p2p-home-example-router-core-isp-b-home-example-router-upstream-core-isp-b";
            attach = {
              bridge = "br-nixos-core-isp-b-upstream";
              kind = "bridge";
            };
            interface = {
              name = "core-b";
            };
            link = "p2p-home-example-router-core-isp-b-home-example-router-upstream";
          };
          core-nebula = {
            adapterName = "p2p-home-example-router-core-nebula-home-example-router-upstream-core-nebula";
            attach = {
              bridge = "br-nixos-core-nebula-upstream";
              kind = "bridge";
            };
            interface = {
              name = "core-nebula";
            };
            link = "p2p-home-example-router-core-nebula-home-example-router-upstream";
          };
          policy-admin-isp-a = {
            adapterName = "p2p-home-example-router-policy-home-example-router-upstream--access-home-example-router-access-admin--uplink-isp-a-policy-admin-isp-a";
            attach = {
              bridge = "br-nixos-policy-upstream-access-admin-isp-a";
              kind = "bridge";
            };
            interface = {
              name = "pol-admin-a";
            };
            link = "p2p-home-example-router-policy-home-example-router-upstream--access-home-example-router-access-admin--uplink-isp-a";
          };
          policy-admin-isp-b = {
            adapterName = "p2p-home-example-router-policy-home-example-router-upstream--access-home-example-router-access-admin--uplink-isp-b-policy-admin-isp-b";
            attach = {
              bridge = "br-nixos-policy-upstream-access-admin-isp-b";
              kind = "bridge";
            };
            interface = {
              name = "pol-admin-b";
            };
            link = "p2p-home-example-router-policy-home-example-router-upstream--access-home-example-router-access-admin--uplink-isp-b";
          };
          policy-client-isp-a = {
            adapterName = "p2p-home-example-router-policy-home-example-router-upstream--access-home-example-router-access-client--uplink-isp-a-policy-client-isp-a";
            attach = {
              bridge = "br-nixos-policy-upstream-access-client-isp-a";
              kind = "bridge";
            };
            interface = {
              name = "pol-client-a";
            };
            link = "p2p-home-example-router-policy-home-example-router-upstream--access-home-example-router-access-client--uplink-isp-a";
          };
          policy-client-isp-b = {
            adapterName = "p2p-home-example-router-policy-home-example-router-upstream--access-home-example-router-access-client--uplink-isp-b-policy-client-isp-b";
            attach = {
              bridge = "br-nixos-policy-upstream-access-client-isp-b";
              kind = "bridge";
            };
            interface = {
              name = "pol-client-b";
            };
            link = "p2p-home-example-router-policy-home-example-router-upstream--access-home-example-router-access-client--uplink-isp-b";
          };
          policy-dmz-isp-a = {
            adapterName = "p2p-home-example-router-policy-home-example-router-upstream--access-home-example-router-access-dmz--uplink-isp-a-policy-dmz-isp-a";
            attach = {
              bridge = "br-nixos-policy-upstream-access-dmz-isp-a";
              kind = "bridge";
            };
            interface = {
              name = "pol-dmz-a";
            };
            link = "p2p-home-example-router-policy-home-example-router-upstream--access-home-example-router-access-dmz--uplink-isp-a";
          };
          policy-dmz-isp-b = {
            adapterName = "p2p-home-example-router-policy-home-example-router-upstream--access-home-example-router-access-dmz--uplink-isp-b-policy-dmz-isp-b";
            attach = {
              bridge = "br-nixos-policy-upstream-access-dmz-isp-b";
              kind = "bridge";
            };
            interface = {
              name = "pol-dmz-b";
            };
            link = "p2p-home-example-router-policy-home-example-router-upstream--access-home-example-router-access-dmz--uplink-isp-b";
          };
          policy-hostile-east-west = {
            adapterName = "p2p-home-example-router-policy-home-example-router-upstream--access-home-example-router-access-hostile--uplink-east-west-policy-hostile-east-west";
            attach = {
              bridge = "br-nixos-policy-upstream-access-hostile-east-west";
              kind = "bridge";
            };
            interface = {
              name = "pol-hostile-ew";
            };
            link = "p2p-home-example-router-policy-home-example-router-upstream--access-home-example-router-access-hostile--uplink-east-west";
          };
          policy-mgmt-isp-a = {
            adapterName = "p2p-home-example-router-policy-home-example-router-upstream--access-home-example-router-access-mgmt--uplink-isp-a-policy-mgmt-isp-a";
            attach = {
              bridge = "br-nixos-policy-upstream-access-mgmt-isp-a";
              kind = "bridge";
            };
            interface = {
              name = "pol-mgmt-a";
            };
            link = "p2p-home-example-router-policy-home-example-router-upstream--access-home-example-router-access-mgmt--uplink-isp-a";
          };
          policy-mgmt-isp-b = {
            adapterName = "p2p-home-example-router-policy-home-example-router-upstream--access-home-example-router-access-mgmt--uplink-isp-b-policy-mgmt-isp-b";
            attach = {
              bridge = "br-nixos-policy-upstream-access-mgmt-isp-b";
              kind = "bridge";
            };
            interface = {
              name = "pol-mgmt-b";
            };
            link = "p2p-home-example-router-policy-home-example-router-upstream--access-home-example-router-access-mgmt--uplink-isp-b";
          };
          policy-streaming-isp-a = {
            adapterName = "p2p-home-example-router-policy-home-example-router-upstream--access-home-example-router-access-streaming--uplink-isp-a-policy-streaming-isp-a";
            attach = {
              bridge = "br-nixos-policy-upstream-access-streaming-isp-a";
              kind = "bridge";
            };
            interface = {
              name = "pol-stream-a";
            };
            link = "p2p-home-example-router-policy-home-example-router-upstream--access-home-example-router-access-streaming--uplink-isp-a";
          };
          policy-streaming-isp-b = {
            adapterName = "p2p-home-example-router-policy-home-example-router-upstream--access-home-example-router-access-streaming--uplink-isp-b-policy-streaming-isp-b";
            attach = {
              bridge = "br-nixos-policy-upstream-access-streaming-isp-b";
              kind = "bridge";
            };
            interface = {
              name = "pol-stream-b";
            };
            link = "p2p-home-example-router-policy-home-example-router-upstream--access-home-example-router-access-streaming--uplink-isp-b";
          };
        };
      };
      esp-edge-example-router-access-client = {
        advertisements = {
          dhcp4 = {
            tenant-client = {
              dnsServers = [ "router-self" ];
              domain = "lan.";
              id = "client";
              interface = "tenant-client";
              pool = {
                end = "10.90.20.200";
                start = "10.90.20.100";
              };
              router = "10.90.20.1";
              subnet = "10.90.20.0/24";
            };
          };
          ipv6Ra = {
            tenant-client = {
              dnssl = [ "lan." ];
              interface = "tenant-client";
              prefixes = [ "fd42:dead:cafe:20::/64" ];
              rdnss = [ "router-self" ];
            };
          };
        };
        host = "s-router-hetzner-anywhere";
        logicalNode = {
          enterprise = "esp";
          name = "edge-example-router-access-client";
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
              addr4 = "10.90.20.1/24";
              addr6 = "fd42:dead:cafe:20::1/64";
              name = "tenant-client";
            };
            logicalInterface = "tenant-client";
          };
          transit-downstream = {
            adapterName = "p2p-edge-example-router-access-client-edge-example-router-downstream-transit-downstream";
            attach = {
              bridge = "br-hetz-downstream-client";
              kind = "bridge";
            };
            interface = {
              name = "transit";
            };
            link = "p2p-edge-example-router-access-client-edge-example-router-downstream";
          };
        };
        services = {
          dns = {
            advertised = {
              dnsServers = [ "router-self" ];
              rdnss = [ "router-self" ];
            };
            allowFrom = [
              "10.90.20.0/24"
              "fd42:dead:cafe:20::/64"
            ];
            forwarders = [
              "1.1.1.1"
              "1.0.0.1"
              "2606:4700:4700::1111"
              "2606:4700:4700::1001"
            ];
            listen = [
              "10.90.20.1"
              "fd42:dead:cafe:20::1"
            ];
          };
        };
      };
      esp-edge-example-router-access-dmz = {
        advertisements = {
          dhcp4 = {
            tenant-dmz = {
              dnsServers = [ "router-self" ];
              domain = "lan.";
              id = "dmz";
              interface = "tenant-dmz";
              pool = {
                end = "10.90.10.200";
                start = "10.90.10.100";
              };
              router = "10.90.10.1";
              subnet = "10.90.10.0/24";
            };
          };
          ipv6Ra = {
            tenant-dmz = {
              dnssl = [ "lan." ];
              interface = "tenant-dmz";
              prefixes = [ "fd42:dead:cafe:10::/64" ];
              rdnss = [ "router-self" ];
            };
          };
        };
        host = "s-router-hetzner-anywhere";
        logicalNode = {
          enterprise = "esp";
          name = "edge-example-router-access-dmz";
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
              addr4 = "10.90.10.1/24";
              addr6 = "fd42:dead:cafe:10::1/64";
              name = "tenant-dmz";
            };
            logicalInterface = "tenant-dmz";
          };
          transit-downstream = {
            adapterName = "p2p-edge-example-router-access-dmz-edge-example-router-downstream-transit-downstream";
            attach = {
              bridge = "br-hetz-downstream-dmz";
              kind = "bridge";
            };
            interface = {
              name = "transit";
            };
            link = "p2p-edge-example-router-access-dmz-edge-example-router-downstream";
          };
        };
        services = {
          dns = {
            advertised = {
              dnsServers = [ "router-self" ];
              rdnss = [ "router-self" ];
            };
            allowFrom = [
              "10.90.10.0/24"
              "fd42:dead:cafe:10::/64"
            ];
            forwarders = [
              "1.1.1.1"
              "1.0.0.1"
              "2606:4700:4700::1111"
              "2606:4700:4700::1001"
            ];
            listen = [
              "10.90.10.1"
              "fd42:dead:cafe:10::1"
            ];
          };
        };
      };
      esp-edge-example-router-core = {
        host = "s-router-hetzner-anywhere";
        logicalNode = {
          enterprise = "esp";
          name = "edge-example-router-core";
          site = "hetz";
        };
        platform = "nixos-container";
        ports = {
          upstream = {
            adapterName = "p2p-edge-example-router-core-edge-example-router-upstream-upstream";
            attach = {
              bridge = "br-hetz-core-upstream";
              kind = "bridge";
            };
            interface = {
              name = "upstream";
            };
            link = "p2p-edge-example-router-core-edge-example-router-upstream";
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
      esp-edge-example-router-downstream = {
        host = "s-router-hetzner-anywhere";
        logicalNode = {
          enterprise = "esp";
          name = "edge-example-router-downstream";
          site = "hetz";
        };
        platform = "nixos-container";
        ports = {
          access-client = {
            adapterName = "p2p-edge-example-router-access-client-edge-example-router-downstream-access-client";
            attach = {
              bridge = "br-hetz-downstream-client";
              kind = "bridge";
            };
            interface = {
              name = "access-client";
            };
            link = "p2p-edge-example-router-access-client-edge-example-router-downstream";
          };
          access-dmz = {
            adapterName = "p2p-edge-example-router-access-dmz-edge-example-router-downstream-access-dmz";
            attach = {
              bridge = "br-hetz-downstream-dmz";
              kind = "bridge";
            };
            interface = {
              name = "access-dmz";
            };
            link = "p2p-edge-example-router-access-dmz-edge-example-router-downstream";
          };
          policy-client = {
            adapterName = "p2p-edge-example-router-downstream-edge-example-router-policy--access-edge-example-router-access-client-policy-client";
            attach = {
              bridge = "br-hetz-downstream-policy-access-client";
              kind = "bridge";
            };
            interface = {
              name = "policy-client";
            };
            link = "p2p-edge-example-router-downstream-edge-example-router-policy--access-edge-example-router-access-client";
          };
          policy-dmz = {
            adapterName = "p2p-edge-example-router-downstream-edge-example-router-policy--access-edge-example-router-access-dmz-policy-dmz";
            attach = {
              bridge = "br-hetz-downstream-policy-access-dmz";
              kind = "bridge";
            };
            interface = {
              name = "policy-dmz";
            };
            link = "p2p-edge-example-router-downstream-edge-example-router-policy--access-edge-example-router-access-dmz";
          };
        };
      };
      esp-edge-example-router-nebula-core = {
        host = "s-router-hetzner-anywhere";
        logicalNode = {
          enterprise = "esp";
          name = "edge-example-router-nebula-core";
          site = "hetz";
        };
        platform = "nixos-container";
        ports = {
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
            adapterName = "p2p-edge-example-router-nebula-core-edge-example-router-upstream-upstream";
            attach = {
              bridge = "br-hetz-nebula-core-upstream";
              kind = "bridge";
            };
            interface = {
              name = "upstream";
            };
            link = "p2p-edge-example-router-nebula-core-edge-example-router-upstream";
          };
        };
      };
      esp-edge-example-router-policy = {
        host = "s-router-hetzner-anywhere";
        logicalNode = {
          enterprise = "esp";
          name = "edge-example-router-policy";
          site = "hetz";
        };
        platform = "nixos-container";
        ports = {
          downstream-client = {
            adapterName = "p2p-edge-example-router-downstream-edge-example-router-policy--access-edge-example-router-access-client-downstream-client";
            attach = {
              bridge = "br-hetz-downstream-policy-access-client";
              kind = "bridge";
            };
            interface = {
              name = "downstream-client";
            };
            link = "p2p-edge-example-router-downstream-edge-example-router-policy--access-edge-example-router-access-client";
          };
          downstream-dmz = {
            adapterName = "p2p-edge-example-router-downstream-edge-example-router-policy--access-edge-example-router-access-dmz-downstream-dmz";
            attach = {
              bridge = "br-hetz-downstream-policy-access-dmz";
              kind = "bridge";
            };
            interface = {
              name = "downstream-dmz";
            };
            link = "p2p-edge-example-router-downstream-edge-example-router-policy--access-edge-example-router-access-dmz";
          };
          upstream-client-wan = {
            adapterName = "p2p-edge-example-router-policy-edge-example-router-upstream--access-edge-example-router-access-client--uplink-wan-upstream-client-wan";
            attach = {
              bridge = "br-hetz-policy-upstream-access-client-wan";
              kind = "bridge";
            };
            interface = {
              name = "up-client-wan";
            };
            link = "p2p-edge-example-router-policy-edge-example-router-upstream--access-edge-example-router-access-client--uplink-wan";
          };
          upstream-dmz-wan = {
            adapterName = "p2p-edge-example-router-policy-edge-example-router-upstream--access-edge-example-router-access-dmz--uplink-wan-upstream-dmz-wan";
            attach = {
              bridge = "br-hetz-policy-upstream-access-dmz-wan";
              kind = "bridge";
            };
            interface = {
              name = "up-dmz-wan";
            };
            link = "p2p-edge-example-router-policy-edge-example-router-upstream--access-edge-example-router-access-dmz--uplink-wan";
          };
        };
      };
      esp-edge-example-router-upstream = {
        host = "s-router-hetzner-anywhere";
        logicalNode = {
          enterprise = "esp";
          name = "edge-example-router-upstream";
          site = "hetz";
        };
        platform = "nixos-container";
        ports = {
          core = {
            adapterName = "p2p-edge-example-router-core-edge-example-router-upstream-core";
            attach = {
              bridge = "br-hetz-core-upstream";
              kind = "bridge";
            };
            interface = {
              name = "core";
            };
            link = "p2p-edge-example-router-core-edge-example-router-upstream";
          };
          core-nebula = {
            adapterName = "p2p-edge-example-router-nebula-core-edge-example-router-upstream-core-nebula";
            attach = {
              bridge = "br-hetz-nebula-core-upstream";
              kind = "bridge";
            };
            interface = {
              name = "core-nebula";
            };
            link = "p2p-edge-example-router-nebula-core-edge-example-router-upstream";
          };
          policy-client-wan = {
            adapterName = "p2p-edge-example-router-policy-edge-example-router-upstream--access-edge-example-router-access-client--uplink-wan-policy-client-wan";
            attach = {
              bridge = "br-hetz-policy-upstream-access-client-wan";
              kind = "bridge";
            };
            interface = {
              name = "policy-client-wan";
            };
            link = "p2p-edge-example-router-policy-edge-example-router-upstream--access-edge-example-router-access-client--uplink-wan";
          };
          policy-dmz-wan = {
            adapterName = "p2p-edge-example-router-policy-edge-example-router-upstream--access-edge-example-router-access-dmz--uplink-wan-policy-dmz-wan";
            attach = {
              bridge = "br-hetz-policy-upstream-access-dmz-wan";
              kind = "bridge";
            };
            interface = {
              name = "policy-dmz-wan";
            };
            link = "p2p-edge-example-router-policy-edge-example-router-upstream--access-edge-example-router-access-dmz--uplink-wan";
          };
        };
      };
    } // clabAccessNodes // {
      esp-lab-example-router-core-nebula = {
        host = "s-router-clab";
        logicalNode = {
          enterprise = "esp";
          name = "lab-example-router-core-nebula";
          site = "clab";
        };
        platform = "nixos-container";
        ports = {
          east-west = {
            attach = {
              bridge = "br-uplink1";
              kind = "bridge";
            };
            external = true;
            interface = {
              name = "east-west";
            };
            uplink = "east-west";
          };
          upstream = {
            adapterName = "p2p-lab-example-router-core-nebula-lab-example-router-upstream-upstream";
            attach = {
              bridge = "br-clab-core-nebula-upstream";
              kind = "bridge";
            };
            interface = {
              name = "upstream";
            };
            link = "p2p-lab-example-router-core-nebula-lab-example-router-upstream";
          };
        };
      };
      esp-lab-example-router-core-simulated-isp = {
        host = "s-router-clab";
        logicalNode = {
          enterprise = "esp";
          name = "lab-example-router-core-simulated-isp";
          site = "clab";
        };
        platform = "nixos-container";
        ports = {
          upstream = {
            adapterName = "p2p-lab-example-router-core-simulated-isp-lab-example-router-upstream-upstream";
            attach = {
              bridge = "br-clab-core-simulated-isp-upstream";
              kind = "bridge";
            };
            interface = {
              name = "upstream";
            };
            link = "p2p-lab-example-router-core-simulated-isp-lab-example-router-upstream";
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
      esp-lab-example-router-downstream = {
        host = "s-router-clab";
        logicalNode = {
          enterprise = "esp";
          name = "lab-example-router-downstream";
          site = "clab";
        };
        platform = "nixos-container";
        ports = clabDownstreamAccessPorts // clabDownstreamPolicyPorts;
      };
      esp-lab-example-router-policy = {
        host = "s-router-clab";
        logicalNode = {
          enterprise = "esp";
          name = "lab-example-router-policy";
          site = "clab";
        };
        platform = "nixos-container";
        ports = clabPolicyDownstreamPorts // clabPolicyWanPorts // clabPolicyEastWestPorts;
      };
      esp-lab-example-router-upstream = {
        host = "s-router-clab";
        logicalNode = {
          enterprise = "esp";
          name = "lab-example-router-upstream";
          site = "clab";
        };
        platform = "nixos-container";
        ports = {
          core-nebula = {
            adapterName = "p2p-lab-example-router-core-nebula-lab-example-router-upstream-core-nebula";
            attach = {
              bridge = "br-clab-core-nebula-upstream";
              kind = "bridge";
            };
            interface = {
              name = "core-nebula";
            };
            link = "p2p-lab-example-router-core-nebula-lab-example-router-upstream";
          };
          core-simulated-isp = {
            adapterName = "p2p-lab-example-router-core-simulated-isp-lab-example-router-upstream-core-simulated-isp";
            attach = {
              bridge = "br-clab-core-simulated-isp-upstream";
              kind = "bridge";
            };
            interface = {
              name = "core-isp";
            };
            link = "p2p-lab-example-router-core-simulated-isp-lab-example-router-upstream";
          };
        } // clabUpstreamWanPorts // clabUpstreamEastWestPorts;
      };
    };
  };
}
