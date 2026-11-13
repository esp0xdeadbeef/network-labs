{
  controlPlane = {
    sites = {
      esp0xdeadbeef = {
        site-a = {
          overlays = {
            nebula = {
              nodes = {
                s-router-core-nebula = {
                  addr4 = "100.96.10.1/32";
                  addr6 = "fd42:dead:beef:ee::1/128";
                };
              };
              nebula = {
                lighthouse = {
                  addr4 = "100.96.10.1/24";
                  addr6 = "fd42:dead:beef:ee::1/64";
                  endpoint = "198.51.100.20";
                  endpoint6 = "2001:db8:200::20";
                  # FS-460-HDS-010-SDS-010-SMS-070 requires a target-only secret
                  # path to be a reference the trace can name, not a carried
                  # value.
                  endpointSourceFile = "/run/secrets/nebula-lighthouse-endpoint4";
                  node = "s-router-core-nebula";
                  port = 4242;
                };
                role = "lighthouse";
              };
              provider = "nebula";
            };
            # WireGuard provider overlay. FS-470-HDS-010-SDS-010-SMS-090 asserts
            # that each WireGuard overlay's tunnel MTU is derived from the overlay
            # declaration and bound onto the matching access advertisements, and it
            # reads `providerContract.profile.generatedPeer.mtu`. FS-460-SMS-070
            # additionally traces the contract's ports and MTU to the declaration
            # and requires a target-only secret path to be a reference.
            "wg-egress" = {
              provider = "wireguard";
              providerContract = {
                id = "wg-egress";
                provider = {
                  class = "commercial-imported";
                  mode = "egress-only";
                  prefixAuthority = "host-only-128";
                };
                interfaces = {
                  wan = "wan";
                  lan = "up-sel";
                  vpn = "overlay-wg-egress";
                };
                profile = {
                  mode = "generated-peer";
                  generatedPeer = {
                    privateKeyFile = "/run/secrets/wg-egress-private-key";
                    addressesFile = "/run/secrets/wg-egress-address";
                    dnsFile = "/run/secrets/wg-egress-dns";
                    mtu = 1320;
                    peers = [
                      {
                        publicKeyFile = "/run/secrets/wg-egress-public-key";
                        endpointFile = "/run/secrets/wg-egress-endpoint";
                        presharedKeyFile = "/run/secrets/wg-egress-preshared-key";
                        allowedIPs = [ "0.0.0.0/0" "::/0" ];
                        persistentKeepalive = 15;
                      }
                    ];
                  };
                };
                runtime = {
                  uuidFile = "/run/network-renderer-wireguard/wg-egress.uuid";
                  generatedConfigPath = "/run/network-renderer-wireguard/wg-egress.conf";
                };
                lan = {
                  ipv4.address = "10.96.10.2/32";
                  ipv6.address = "fd42:dead:beef:ee00::2/128";
                };
                wan = {
                  ipv4.method = "auto";
                  ipv6.method = "auto";
                };
                dns.mode = "default";
                firewall.mode = null;
                nat = {
                  ipv4 = {
                    enable = true;
                    sourceCidrs = [ "10.20.10.0/24" ];
                  };
                  ipv6 = {
                    enable = true;
                    sourceCidrs = [ "fd42:dead:beef:10::/64" ];
                  };
                };
                publicIngress = [ ];
                portForwards = [ ];
                services = {
                  dhcp4.enable = false;
                  ra.enable = false;
                  healthCheck = {
                    enable = true;
                    interval = "30s";
                  };
                };
              };
              runtimeNodes = { };
            };
          };
        };
      };
    };
  };
  deployment = {
    hosts = {
      lab-host = {
        bridgeNetworks = {
          br-site-a-core-nebula-upstream = { };
          br-site-a-core-wan-upstream = { };
          br-site-a-downstream-admin = { };
          br-site-a-downstream-client = { };
          br-site-a-downstream-mgmt = { };
          br-site-a-downstream-policy-access-admin = { };
          br-site-a-downstream-policy-access-client = { };
          br-site-a-downstream-policy-access-mgmt = { };
          br-site-a-policy-upstream-access-admin-nebula = { };
          br-site-a-policy-upstream-access-admin-wg-egress = { };
          br-site-a-policy-upstream-access-client-wan = { };
        };
        uplinks = {
          nebula = {
            bridge = "br-site-a-core-nebula-uplink";
            ipv4 = {
              method = "dhcp";
            };
            ipv6 = {
              method = "slaac";
            };
            parent = "eno2";
          };
          uplink0 = {
            bridge = "br-uplink0";
            ipv4 = {
              method = "dhcp";
            };
            ipv6 = {
              method = "slaac";
            };
            parent = "eno1";
          };
        };
        wanGroupToUplink = {
          "esp0xdeadbeef::site-a::s-router-core-wan" = "uplink0";
        };
      };
    };
  };
  endpoints = {
    site-dns = {
      ipv4 = [ "10.20.10.10" ];
      ipv6 = [ "fd42:dead:beef:10::10" ];
    };
  };
  realization = {
    nodes = {
      esp0xdeadbeef-site-a-s-router-access-admin = {
        # FS-800-HDS-030-SDS-020-SMS-030 consumes IAID and the PD request
        # identity and publishes one active generation identity plus an opaque
        # prefix handle. A PPPoE customer-side handoff with DHCPv6-PD is the
        # modeled shape for that; the credentials are file references, never
        # values.
        services = {
          pppoe = {
            client = {
              interface = "wan";
              runtimeInterface = "ppp0";
              defaultRoute = true;
              usePeerDns = false;
              mtu = 1492;
              credentials = {
                usernameFile = "/run/secrets/pppoe-username";
                passwordFile = "/run/secrets/pppoe-password";
              };
              ipv6 = {
                mode = "dhcpv6-pd";
                defaultRoute = true;
                iaid = 1;
                prefixDelegationRequestId = 1;
                duidMode = "persistent";
                resolverMode = "disabled";
                ipv4Mode = "disabled";
                routerSolicitation = false;
                fallbackPolicy = "none";
              };
            };
          };
        };
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
        services.dns = { };
        host = "lab-host";
        logicalNode = {
          enterprise = "esp0xdeadbeef";
          name = "s-router-access-admin";
          site = "site-a";
        };
        platform = "linux";
        ports = {
          transit-downstream-selector = {
            adapterName = "adp-esp0xdeadbeef-site-a-s-router-access-admin-transit-downstream-selector";
            attach = {
              bridge = "br-site-a-downstream-admin";
              kind = "bridge";
            };
            interface = {
              name = "ens3";
            };
            link = "p2p-s-router-access-admin-s-router-downstream-selector";
          };
        };
      };
      esp0xdeadbeef-site-a-s-router-access-client = {
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
        services.dns = { };
        host = "lab-host";
        logicalNode = {
          enterprise = "esp0xdeadbeef";
          name = "s-router-access-client";
          site = "site-a";
        };
        platform = "linux";
        ports = {
          transit-downstream-selector = {
            adapterName = "adp-esp0xdeadbeef-site-a-s-router-access-client-transit-downstream-selector";
            attach = {
              bridge = "br-site-a-downstream-client";
              kind = "bridge";
            };
            interface = {
              name = "ens3";
            };
            link = "p2p-s-router-access-client-s-router-downstream-selector";
          };
        };
      };
      esp0xdeadbeef-site-a-s-router-access-mgmt = {
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
        services.dns = { };
        host = "lab-host";
        logicalNode = {
          enterprise = "esp0xdeadbeef";
          name = "s-router-access-mgmt";
          site = "site-a";
        };
        platform = "linux";
        ports = {
          transit-downstream-selector = {
            adapterName = "adp-esp0xdeadbeef-site-a-s-router-access-mgmt-transit-downstream-selector";
            attach = {
              bridge = "br-site-a-downstream-mgmt";
              kind = "bridge";
            };
            interface = {
              name = "ens3";
            };
            link = "p2p-s-router-access-mgmt-s-router-downstream-selector";
          };
        };
      };
      esp0xdeadbeef-site-a-s-router-core-nebula = {
        host = "lab-host";
        logicalNode = {
          enterprise = "esp0xdeadbeef";
          name = "s-router-core-nebula";
          site = "site-a";
        };
        platform = "linux";
        ports = {
          nebula = {
            attach = {
              bridge = "br-site-a-core-nebula-uplink";
              kind = "bridge";
            };
            external = true;
            interface = {
              name = "ens4";
            };
            uplink = "nebula";
          };
          upstream-selector = {
            adapterName = "adp-esp0xdeadbeef-site-a-s-router-core-nebula-upstream-selector";
            attach = {
              bridge = "br-site-a-core-nebula-upstream";
              kind = "bridge";
            };
            interface = {
              name = "ens3";
            };
            link = "p2p-s-router-core-nebula-s-router-upstream-selector";
          };
        };
      };
      esp0xdeadbeef-site-a-s-router-core-wan = {
        host = "lab-host";
        logicalNode = {
          enterprise = "esp0xdeadbeef";
          name = "s-router-core-wan";
          site = "site-a";
        };
        platform = "linux";
        ports = {
          upstream-selector = {
            adapterName = "adp-esp0xdeadbeef-site-a-s-router-core-wan-upstream-selector";
            attach = {
              bridge = "br-site-a-core-wan-upstream";
              kind = "bridge";
            };
            interface = {
              name = "ens3";
            };
            link = "p2p-s-router-core-wan-s-router-upstream-selector";
          };
          wan = {
            attach = {
              bridge = "br-uplink0";
              kind = "bridge";
            };
            external = true;
            interface = {
              name = "ens4";
            };
            uplink = "wan";
          };
        };
      };
      esp0xdeadbeef-site-a-s-router-downstream-selector = {
        host = "lab-host";
        logicalNode = {
          enterprise = "esp0xdeadbeef";
          name = "s-router-downstream-selector";
          site = "site-a";
        };
        platform = "linux";
        ports = {
          access-admin = {
            adapterName = "adp-esp0xdeadbeef-site-a-s-router-downstream-selector-access-admin";
            attach = {
              bridge = "br-site-a-downstream-admin";
              kind = "bridge";
            };
            interface = {
              name = "ens7";
            };
            link = "p2p-s-router-access-admin-s-router-downstream-selector";
          };
          access-client = {
            adapterName = "adp-esp0xdeadbeef-site-a-s-router-downstream-selector-access-client";
            attach = {
              bridge = "br-site-a-downstream-client";
              kind = "bridge";
            };
            interface = {
              name = "ens6";
            };
            link = "p2p-s-router-access-client-s-router-downstream-selector";
          };
          access-mgmt = {
            adapterName = "adp-esp0xdeadbeef-site-a-s-router-downstream-selector-access-mgmt";
            attach = {
              bridge = "br-site-a-downstream-mgmt";
              kind = "bridge";
            };
            interface = {
              name = "ens8";
            };
            link = "p2p-s-router-access-mgmt-s-router-downstream-selector";
          };
          policy-access-admin = {
            adapterName = "adp-esp0xdeadbeef-site-a-s-router-downstream-selector-policy-access-admin";
            attach = {
              bridge = "br-site-a-downstream-policy-access-admin";
              kind = "bridge";
            };
            interface = {
              name = "ens4";
            };
            link = "p2p-s-router-downstream-selector-s-router-policy--access-s-router-access-admin";
          };
          policy-access-client = {
            adapterName = "adp-esp0xdeadbeef-site-a-s-router-downstream-selector-policy-access-client";
            attach = {
              bridge = "br-site-a-downstream-policy-access-client";
              kind = "bridge";
            };
            interface = {
              name = "ens3";
            };
            link = "p2p-s-router-downstream-selector-s-router-policy--access-s-router-access-client";
          };
          policy-access-mgmt = {
            adapterName = "adp-esp0xdeadbeef-site-a-s-router-downstream-selector-policy-access-mgmt";
            attach = {
              bridge = "br-site-a-downstream-policy-access-mgmt";
              kind = "bridge";
            };
            interface = {
              name = "ens5";
            };
            link = "p2p-s-router-downstream-selector-s-router-policy--access-s-router-access-mgmt";
          };
        };
      };
      esp0xdeadbeef-site-a-s-router-policy = {
        host = "lab-host";
        logicalNode = {
          enterprise = "esp0xdeadbeef";
          name = "s-router-policy";
          site = "site-a";
        };
        platform = "linux";
        ports = {
          downstream-access-admin = {
            adapterName = "adp-esp0xdeadbeef-site-a-s-router-policy-downstream-access-admin";
            attach = {
              bridge = "br-site-a-downstream-policy-access-admin";
              kind = "bridge";
            };
            interface = {
              name = "ens6";
            };
            link = "p2p-s-router-downstream-selector-s-router-policy--access-s-router-access-admin";
          };
          downstream-access-client = {
            adapterName = "adp-esp0xdeadbeef-site-a-s-router-policy-downstream-access-client";
            attach = {
              bridge = "br-site-a-downstream-policy-access-client";
              kind = "bridge";
            };
            interface = {
              name = "ens5";
            };
            link = "p2p-s-router-downstream-selector-s-router-policy--access-s-router-access-client";
          };
          downstream-access-mgmt = {
            adapterName = "adp-esp0xdeadbeef-site-a-s-router-policy-downstream-access-mgmt";
            attach = {
              bridge = "br-site-a-downstream-policy-access-mgmt";
              kind = "bridge";
            };
            interface = {
              name = "ens7";
            };
            link = "p2p-s-router-downstream-selector-s-router-policy--access-s-router-access-mgmt";
          };
          upstream-access-admin-nebula = {
            adapterName = "adp-esp0xdeadbeef-site-a-s-router-policy-upstream-access-admin-nebula";
            attach = {
              bridge = "br-site-a-policy-upstream-access-admin-nebula";
              kind = "bridge";
            };
            interface = {
              name = "ens4";
            };
            link = "p2p-s-router-policy-s-router-upstream-selector--access-s-router-access-admin--uplink-nebula";
          };
          upstream-access-admin-wg-egress = {
            adapterName = "adp-esp0xdeadbeef-site-a-s-router-policy-upstream-access-admin-wg-egress";
            attach = {
              bridge = "br-site-a-policy-upstream-access-admin-wg-egress";
              kind = "bridge";
            };
            interface = {
              name = "ens9";
            };
            link = "p2p-s-router-policy-s-router-upstream-selector--access-s-router-access-admin--uplink-wg-egress";
          };
          upstream-access-client-wan = {
            adapterName = "adp-esp0xdeadbeef-site-a-s-router-policy-upstream-access-client-wan";
            attach = {
              bridge = "br-site-a-policy-upstream-access-client-wan";
              kind = "bridge";
            };
            interface = {
              name = "ens3";
            };
            link = "p2p-s-router-policy-s-router-upstream-selector--access-s-router-access-client--uplink-wan";
          };
        };
      };
      esp0xdeadbeef-site-a-s-router-upstream-selector = {
        # A PPPoE server target must explicitly disable DHCP4 and IPv6 RA/SLAAC
        # fallback before renderer handoff.
        advertisements = {
          dhcp4 = {
            tenant-admin = { enabled = false; };
          };
          ipv6Ra = {
            tenant-admin = { enabled = false; };
          };
        };
        # PPPoE server side of the DHCPv6-PD handoff modeled on the admin access
        # node; the protocol requires exactly one client and one server.
        services = {
          pppoe = {
            server = {
              interface = "wan";
              implementation = "rp-pppoe";
              providerAddress = "100.64.0.1";
              customerAddress = "100.64.0.2";
              maxSessions = 1;
              mtu = 1492;
              credentials = {
                usernameFile = "/run/secrets/pppoe-username";
                passwordFile = "/run/secrets/pppoe-password";
              };
            };
          };
        };
        host = "lab-host";
        logicalNode = {
          enterprise = "esp0xdeadbeef";
          name = "s-router-upstream-selector";
          site = "site-a";
        };
        platform = "linux";
        ports = {
          core-nebula = {
            adapterName = "adp-esp0xdeadbeef-site-a-s-router-upstream-selector-core-nebula";
            attach = {
              bridge = "br-site-a-core-nebula-upstream";
              kind = "bridge";
            };
            interface = {
              name = "ens6";
            };
            link = "p2p-s-router-core-nebula-s-router-upstream-selector";
          };
          core-wan = {
            adapterName = "adp-esp0xdeadbeef-site-a-s-router-upstream-selector-core-wan";
            attach = {
              bridge = "br-site-a-core-wan-upstream";
              kind = "bridge";
            };
            interface = {
              name = "ens3";
            };
            link = "p2p-s-router-core-wan-s-router-upstream-selector";
          };
          policy-access-admin-nebula = {
            adapterName = "adp-esp0xdeadbeef-site-a-s-router-upstream-selector-policy-access-admin-nebula";
            attach = {
              bridge = "br-site-a-policy-upstream-access-admin-nebula";
              kind = "bridge";
            };
            interface = {
              name = "ens5";
            };
            link = "p2p-s-router-policy-s-router-upstream-selector--access-s-router-access-admin--uplink-nebula";
          };
          policy-access-admin-wg-egress = {
            adapterName = "adp-esp0xdeadbeef-site-a-s-router-upstream-selector-policy-access-admin-wg-egress";
            attach = {
              bridge = "br-site-a-policy-upstream-access-admin-wg-egress";
              kind = "bridge";
            };
            interface = {
              name = "ens10";
            };
            link = "p2p-s-router-policy-s-router-upstream-selector--access-s-router-access-admin--uplink-wg-egress";
          };
          policy-access-client-wan = {
            adapterName = "adp-esp0xdeadbeef-site-a-s-router-upstream-selector-policy-access-client-wan";
            attach = {
              bridge = "br-site-a-policy-upstream-access-client-wan";
              kind = "bridge";
            };
            interface = {
              name = "ens4";
            };
            link = "p2p-s-router-policy-s-router-upstream-selector--access-s-router-access-client--uplink-wan";
          };
        };
      };
    };
  };
}
